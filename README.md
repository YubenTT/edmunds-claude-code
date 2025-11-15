# AI CLI Orchestrator V2

**Production-ready AI CLI orchestration system with browser automation and OAuth support.**

Access 10x larger free tiers from ChatGPT, Claude, Gemini, and DeepSeek through web interfaces instead of API keys.

## ✨ Features

- 🌐 **Browser Automation** - Playwright-based automation with anti-bot stealth mode
- 🔐 **Multi-Account Management** - Rotate across unlimited accounts with 2FA support
- 📊 **Real-time Quota Tracking** - Live dashboard with automatic daily/monthly resets
- 🚀 **Production Ready** - Docker orchestration, monitoring, health checks
- 🔌 **External API** - RESTful gateway for integrating with your apps
- 💰 **Zero Cost** - Use web free tiers instead of paid API quotas

## 🚀 Quick Start

```bash
# 1. Clone and deploy
git clone https://github.com/YubenTT/edmunds-claude-code.git
cd edmunds-claude-code
./deploy.sh

# 2. Access webapp
open http://localhost:3000

# 3. Add your first account via UI
# - Sign in with Supabase Auth
# - Add ChatGPT/Claude account
# - Complete 2FA if prompted

# 4. Start making requests
curl -X POST http://localhost:3001/chat \
  -H "Authorization: Bearer your_api_key" \
  -d '{"prompt": "Hello!", "provider": "auto"}'
```

**System ready in under 30 minutes!** 🎉

See [docs/guides/quickstart.md](docs/guides/quickstart.md) for detailed setup.

## 📦 What's Included

### Core Components

- **React Webapp** (`src/webapp/`) - Account & quota management dashboard
- **Browser Workers** (`src/browser-worker/`) - Playwright automation for ChatGPT, Claude, Gemini, DeepSeek
- **Quota Tracker** (`src/quota-tracker/`) - Real-time monitoring with auto-reset
- **API Gateway** (`src/api/`) - Supabase Edge Functions for external access
- **Monitoring Stack** (`monitoring/`) - Prometheus + Grafana with 15+ alerts

### Documentation

- **Architecture** (`docs/architecture/`) - System design, browser automation, OAuth research
- **Guides** (`docs/guides/`) - Quickstart, deployment, migration from V1
- **Research** (`docs/research/`) - Comprehensive AI CLI analysis across 70+ tools
- **Examples** (`examples/`) - Python, Node.js, and Bash client implementations

### Deployment

- **Docker Compose** - One-command orchestration
- **Automated Script** (`deploy.sh`) - Interactive deployment with validation
- **Environment Config** (`.env.example`) - Complete configuration template

## 📊 Performance

| Metric | V1 (API Keys) | V2 (Browser) | Improvement |
|--------|---------------|--------------|-------------|
| **Daily Quota** | 100-500 requests | 1,000-5,000 requests | **10x** |
| **Monthly Cost** | $20-100 | $0 | **100%** |
| **Concurrency** | Sequential | 3 workers | **3x** |
| **Uptime** | 95% | 99%+ | **4%** |

## 🏗️ Architecture

```
┌─────────────┐      ┌──────────────┐      ┌─────────────────┐
│   Webapp    │◄────►│  API Gateway │◄────►│  Redis Queue    │
│  (React)    │      │  (Supabase)  │      │   (BullMQ)      │
└─────────────┘      └──────────────┘      └────────┬────────┘
                                                     │
                            ┌────────────────────────┼────────────────┐
                            ▼                        ▼                ▼
                    ┌──────────────┐        ┌──────────────┐  ┌──────────────┐
                    │   Worker 1   │        │   Worker 2   │  │   Worker 3   │
                    │ (Playwright) │        │ (Playwright) │  │ (Playwright) │
                    └──────┬───────┘        └──────┬───────┘  └──────┬───────┘
                           │                       │                  │
                           ▼                       ▼                  ▼
                    ┌──────────────┐        ┌──────────────┐  ┌──────────────┐
                    │   ChatGPT    │        │    Claude    │  │    Gemini    │
                    │   (Web UI)   │        │   (Web UI)   │  │   (Web UI)   │
                    └──────────────┘        └──────────────┘  └──────────────┘
```

See [docs/architecture/system-v2.md](docs/architecture/system-v2.md) for complete details.

## 📖 Documentation

### Getting Started
- [Quickstart Guide](docs/guides/quickstart.md) - 30-minute deployment
- [Deployment Guide](docs/guides/deployment.md) - Production hardening
- [Migration from V1](docs/guides/migration-from-v1.md) - Upgrade strategy

### Architecture
- [System Architecture V2](docs/architecture/system-v2.md) - Complete design
- [Browser Automation](docs/architecture/browser-automation.md) - Playwright implementation
- [OAuth Research](docs/architecture/oauth-research.md) - Free tier analysis

### Research
- [Comprehensive Report](docs/research/analysis/comprehensive-report.md) - 70+ AI CLIs analyzed
- [Quota Matrix](docs/research/analysis/quota-matrix.md) - Free tier comparisons
- [Provider Research](docs/research/providers/) - Claude, OpenAI, Gemini, DeepSeek, Grok

### Examples
- [Python Client](examples/python/) - Full-featured client (400+ lines)
- [Node.js Client](examples/nodejs/) - Async/await implementation
- [Bash Client](examples/bash/) - Shell script with curl + jq

## 🔒 Security

- ✅ **SHA-256 Hashed API Keys** - Only hashes stored in database
- ✅ **Row-Level Security** - Multi-tenant isolation in PostgreSQL
- ✅ **Browser Sandboxing** - Resource limits and security flags
- ✅ **Environment Secrets** - Never committed to version control
- ✅ **Rate Limiting** - Prevent abuse on API endpoints

## 📊 Monitoring

- **Prometheus** - Metrics collection from all services
- **Grafana** - 12-panel dashboard (quotas, latency, errors, resources)
- **15+ Alerts** - Quota warnings, system health, performance issues
- **Alert Channels** - Slack, Email, Webhook integrations

See [monitoring/](monitoring/) for setup instructions.

## 🛠️ Development

```bash
# Run in development mode
docker-compose up

# Run with monitoring stack
docker-compose -f docker-compose.yml -f monitoring/docker-compose.monitoring.yml up

# View logs
docker-compose logs -f browser-worker-1

# Check health
docker-compose ps
```

## 📂 Project Structure

```
/
├── README.md                       # This file
├── docker-compose.yml              # Main orchestration
├── deploy.sh                       # Automated deployment
├── .env.example                    # Configuration template
│
├── docs/                           # Documentation
│   ├── architecture/               # System design
│   ├── guides/                     # How-to guides
│   ├── research/                   # AI CLI research
│   └── legacy/                     # V1 documentation
│
├── src/                            # Source code
│   ├── webapp/                     # React dashboard
│   ├── browser-worker/             # Playwright automation
│   ├── quota-tracker/              # Monitoring service
│   └── api/                        # Supabase Edge Functions
│
├── examples/                       # Client examples
│   ├── python/                     # Python client
│   ├── nodejs/                     # Node.js client
│   └── bash/                       # Bash client
│
└── monitoring/                     # Prometheus + Grafana
    ├── prometheus.yml              # Metrics config
    ├── alerts.yml                  # Alert rules
    └── grafana-dashboard.json      # Dashboard definition
```

## 🤝 Contributing

Contributions welcome! Please read our [contribution guidelines](CONTRIBUTING.md) first.

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

## 🙏 Acknowledgments

Built with:
- [Playwright](https://playwright.dev/) - Browser automation
- [Supabase](https://supabase.com/) - Backend platform
- [BullMQ](https://docs.bullmq.io/) - Job queue
- [React](https://react.dev/) - Frontend framework
- [Prometheus](https://prometheus.io/) + [Grafana](https://grafana.com/) - Monitoring

## 📞 Support

- **Documentation**: [docs/](docs/)
- **Issues**: [GitHub Issues](https://github.com/YubenTT/edmunds-claude-code/issues)
- **Discussions**: [GitHub Discussions](https://github.com/YubenTT/edmunds-claude-code/discussions)

---

**Made with ❤️ for the AI CLI community**
