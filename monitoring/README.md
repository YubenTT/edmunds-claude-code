# AI CLI Orchestrator V2 - Monitoring Setup

Complete monitoring stack with Prometheus, Grafana, and exporters.

---

## Overview

**Components:**
- **Prometheus** - Metrics collection and storage
- **Grafana** - Visualization and dashboards
- **Node Exporter** - System metrics (CPU, memory, disk)
- **Redis Exporter** - Redis metrics
- **cAdvisor** - Container metrics
- **Alertmanager** - Alert routing and notifications (optional)

---

## Quick Start

### 1. Start Monitoring Stack

```bash
# Start main V2 system first
docker compose -f docker-compose.v2.yml up -d

# Start monitoring
cd monitoring
docker compose -f docker-compose.monitoring.yml up -d
```

### 2. Access Dashboards

**Grafana:**
```
http://localhost:3001

Username: admin
Password: admin
```

**Prometheus:**
```
http://localhost:9090
```

**cAdvisor (Container Metrics):**
```
http://localhost:8080
```

### 3. Import Dashboard

1. Open Grafana: http://localhost:3001
2. Go to Dashboards → Import
3. Upload `grafana-dashboard.json`
4. Select Prometheus as data source
5. Click Import

**Dashboard is now available!**

---

## Metrics Collected

### System Metrics (Node Exporter)

- **CPU Usage** - Per core and total
- **Memory Usage** - Total, available, cached
- **Disk Space** - Available, used, I/O
- **Network** - Bytes sent/received, errors

### Container Metrics (cAdvisor)

- **Container CPU** - Per container usage
- **Container Memory** - Per container memory
- **Container Network** - Per container traffic
- **Container Filesystem** - Per container disk usage

### Redis Metrics (Redis Exporter)

- **Connected Clients** - Number of clients
- **Used Memory** - Memory consumption
- **Commands Processed** - Commands per second
- **Keyspace** - Number of keys

### Application Metrics (Custom)

**Browser Workers:**
- `requests_total` - Total requests processed
- `requests_completed_total` - Successfully completed
- `requests_failed_total` - Failed requests
- `request_duration_seconds` - Latency histogram
- `active_sessions_count` - Active browser sessions

**Quota Tracker:**
- `quota_daily_used` - Daily usage by provider
- `quota_daily_limit` - Daily limit by provider
- `quota_monthly_used` - Monthly usage (if applicable)
- `active_accounts_count` - Number of active accounts
- `expired_sessions_count` - Number of expired sessions

**API Gateway:**
- `api_requests_total` - Total API requests
- `api_latency_seconds` - API latency
- `api_errors_total` - API errors

---

## Alerts

### Configured Alerts

**System:**
- High CPU usage (>80% for 5min)
- High memory usage (>90% for 5min)
- Disk space low (<10%)

**Services:**
- Service down (any service)
- Browser worker down
- Redis down

**Queue:**
- High queue depth (>100 jobs for 10min)
- High job failure rate (>10% for 5min)

**Quota:**
- Quota almost exceeded (>90%)
- Quota exceeded (100%)
- No active accounts available

**Sessions:**
- Session expiring soon (<24h)
- Session expired

**Performance:**
- High latency (P95 >30s)
- High error rate (>10%)

### View Active Alerts

**Prometheus:**
```
http://localhost:9090/alerts
```

**Alertmanager (if configured):**
```
http://localhost:9093
```

---

## Grafana Dashboards

### Main Dashboard

Shows:
- System overview (workers, accounts, queue)
- Requests per minute by provider
- Success rate by provider
- Quota usage (real-time)
- Request latency (P95)
- Error rate
- CPU & memory usage
- Active sessions

**Refresh:** Every 30 seconds
**Time Range:** Last 6 hours (configurable)

### Creating Custom Dashboards

1. Go to Grafana → Dashboards → New Dashboard
2. Add Panel
3. Select Prometheus as data source
4. Enter PromQL query (see examples below)
5. Configure visualization
6. Save dashboard

**Example Queries:**

```promql
# Requests per second by provider
rate(requests_total[1m])

# Success rate
rate(requests_completed_total[5m]) / rate(requests_total[5m])

# Quota usage percentage
quota_daily_used / quota_daily_limit

# P95 latency
histogram_quantile(0.95, rate(request_duration_seconds_bucket[5m]))

# Active accounts
sum(active_accounts_count)

# Queue depth
bullmq_queue_waiting
```

---

## Alerting Configuration

### Slack Integration

Edit `alertmanager.yml`:

```yaml
global:
  slack_api_url: 'https://hooks.slack.com/services/YOUR/WEBHOOK/URL'

route:
  receiver: 'slack-notifications'

receivers:
  - name: 'slack-notifications'
    slack_configs:
      - channel: '#ai-orchestrator-alerts'
        title: 'AI Orchestrator Alert'
        text: '{{ range .Alerts }}{{ .Annotations.description }}{{ end }}'
```

Restart Alertmanager:
```bash
docker compose -f docker-compose.monitoring.yml restart alertmanager
```

### Email Notifications

Edit `alertmanager.yml`:

```yaml
global:
  smtp_smarthost: 'smtp.gmail.com:587'
  smtp_from: 'alerts@example.com'
  smtp_auth_username: 'your-email@gmail.com'
  smtp_auth_password: 'your-app-password'

route:
  receiver: 'email-notifications'

receivers:
  - name: 'email-notifications'
    email_configs:
      - to: 'admin@example.com'
```

### Webhook Integration

```yaml
receivers:
  - name: 'webhook'
    webhook_configs:
      - url: 'http://your-webhook-url/alerts'
        send_resolved: true
```

---

## Troubleshooting

### Prometheus not scraping targets

```bash
# Check Prometheus logs
docker logs ai-prometheus

# Check targets in Prometheus UI
# http://localhost:9090/targets

# Verify network connectivity
docker compose -f docker-compose.monitoring.yml exec prometheus ping browser-worker-1
```

### Grafana not showing data

```bash
# Check Grafana data source
# Grafana → Configuration → Data Sources → Prometheus
# Test connection

# Verify Prometheus has data
# http://localhost:9090/graph
# Run query: up
```

### Alerts not firing

```bash
# Check alert rules
# http://localhost:9090/rules

# Check Alertmanager
# http://localhost:9093

# View Prometheus logs
docker logs ai-prometheus | grep -i alert
```

### High resource usage

```bash
# Check container stats
docker stats

# Reduce Prometheus retention
# Edit prometheus.yml:
# --storage.tsdb.retention.time=7d  # Default: 15d

# Restart Prometheus
docker compose -f docker-compose.monitoring.yml restart prometheus
```

---

## Production Best Practices

### 1. Persistent Storage

Ensure volumes are properly configured:

```bash
# Backup Prometheus data
docker run --rm \
  -v monitoring_prometheus-data:/source \
  -v $(pwd)/backups:/backup \
  alpine tar czf /backup/prometheus-$(date +%Y%m%d).tar.gz -C /source .

# Backup Grafana data
docker run --rm \
  -v monitoring_grafana-data:/source \
  -v $(pwd)/backups:/backup \
  alpine tar czf /backup/grafana-$(date +%Y%m%d).tar.gz -C /source .
```

### 2. Resource Limits

Edit `docker-compose.monitoring.yml`:

```yaml
prometheus:
  deploy:
    resources:
      limits:
        cpus: '1'
        memory: 2G
      reservations:
        memory: 1G
```

### 3. Retention Policy

```yaml
prometheus:
  command:
    - '--storage.tsdb.retention.time=30d'
    - '--storage.tsdb.retention.size=50GB'
```

### 4. Remote Storage (optional)

For long-term storage, use remote write:

```yaml
# prometheus.yml
remote_write:
  - url: "https://your-remote-storage/api/v1/write"
    basic_auth:
      username: "your-username"
      password: "your-password"
```

### 5. High Availability

Run multiple Prometheus instances:

```bash
# Shard by job
docker compose -f docker-compose.monitoring.yml up -d --scale prometheus=2
```

---

## Metrics Endpoints

If you need to add custom metrics to your services:

### Browser Worker

```typescript
// Add to browser-worker/src/metrics.ts
import client from 'prom-client';

const register = new client.Registry();

export const requestCounter = new client.Counter({
  name: 'requests_total',
  help: 'Total number of requests',
  labelNames: ['provider', 'status'],
  registers: [register]
});

export const requestDuration = new client.Histogram({
  name: 'request_duration_seconds',
  help: 'Request duration in seconds',
  labelNames: ['provider'],
  registers: [register]
});

// Expose metrics endpoint
import express from 'express';
const app = express();

app.get('/metrics', async (req, res) => {
  res.set('Content-Type', register.contentType);
  res.end(await register.metrics());
});

app.listen(9090);
```

---

## Support

- **Prometheus Docs:** https://prometheus.io/docs/
- **Grafana Docs:** https://grafana.com/docs/
- **PromQL Guide:** https://prometheus.io/docs/prometheus/latest/querying/basics/

---

## Summary

**Setup:**
```bash
docker compose -f docker-compose.monitoring.yml up -d
```

**Access:**
- Grafana: http://localhost:3001 (admin/admin)
- Prometheus: http://localhost:9090
- Alerts: http://localhost:9090/alerts

**Dashboards:**
- Import `grafana-dashboard.json`
- View real-time metrics
- Set up alerts

**Production:**
- Configure backups
- Set resource limits
- Enable alerting
- Use remote storage for retention

**Monitoring is now live!** 📊
