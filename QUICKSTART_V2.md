# AI CLI Orchestrator V2 - Quick Start Guide

**Get from zero to production in under 30 minutes!**

This guide will help you deploy the complete V2 system step-by-step.

---

## Prerequisites (5 minutes)

### 1. Get a Supabase Account

```bash
# Go to: https://app.supabase.com
# Click "New Project"
# Choose organization and create project
# Wait 2 minutes for project to initialize
```

### 2. Get a VPS (Optional for local testing)

For production, you need a server:

**Recommended: Hetzner Cloud**
- Go to: https://www.hetzner.com/cloud
- Create CPX31 instance (4 vCPU, 8GB RAM) - €11.90/mo
- Choose Ubuntu 22.04
- Add SSH key
- Create server

**Alternatives:**
- DigitalOcean: $24/mo droplet
- Vultr: $12/mo instance
- AWS t3.medium: ~$30/mo

**For testing locally:**
- Use your own computer (requires 4GB+ RAM)

---

## Step 1: Clone Repository (2 minutes)

```bash
# Clone repository
git clone https://github.com/YubenTT/edmunds-claude-code.git
cd edmunds-claude-code

# Checkout the V2 branch
git checkout claude/ai-cli-research-orchestrator-019vwUsD61PLftjWrSNYmrUf
```

---

## Step 2: Deploy Database (5 minutes)

### Get Supabase Credentials

1. Open your Supabase project
2. Go to **Settings → API**
3. Copy these values:

```
Project URL: https://xxxxx.supabase.co
anon/public key: eyJhbGc...
service_role key: eyJhbGc...
```

### Deploy Schema

1. Go to **SQL Editor** in Supabase dashboard
2. Click **New Query**
3. Copy entire contents of `supabase/schema.sql`
4. Paste and click **Run**
5. Wait for "Schema deployed successfully!" message

### Enable Realtime

1. Go to **Database → Replication**
2. Find these tables and toggle them ON:
   - `accounts`
   - `quotas`
   - `requests`
   - `alerts`

**Done!** Your database is ready.

---

## Step 3: Configure Environment (3 minutes)

```bash
# Copy environment template
cp .env.v2.example .env

# Edit with your favorite editor
nano .env
# or
vim .env
# or
code .env
```

**Required changes:**

```env
# Supabase (paste from Step 2)
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
SUPABASE_SERVICE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

# Generate secure secrets (run these commands)
JWT_SECRET=$(openssl rand -hex 32)
API_KEY_SALT=$(openssl rand -hex 32)
SESSION_ENCRYPTION_KEY=$(openssl rand -hex 32)
```

**Optional customization:**

```env
# Browser workers
WORKER_CONCURRENCY=2        # Increase for more parallel requests
HEADLESS_MODE=true          # Set to false for debugging

# Quota tracking
QUOTA_CHECK_INTERVAL=60000  # Check every 60 seconds
ALERT_THRESHOLD=0.9         # Alert at 90% usage
```

Save and close the file.

---

## Step 4: Deploy with Docker (10 minutes)

### Install Docker (if not already installed)

```bash
# One-line installer
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add your user to docker group
sudo usermod -aG docker $USER
newgrp docker

# Verify
docker --version
docker compose version
```

### Build & Start Services

```bash
# Build all images (takes 5-8 minutes first time)
docker compose -f docker-compose.v2.yml build

# Start all services
docker compose -f docker-compose.v2.yml up -d

# Check status
docker compose -f docker-compose.v2.yml ps
```

**You should see:**

```
NAME                STATUS              PORTS
ai-webapp           Up 10 seconds       0.0.0.0:3000->80/tcp
ai-redis            Up 10 seconds       0.0.0.0:6379->6379/tcp
ai-browser-worker-1 Up 10 seconds
ai-browser-worker-2 Up 10 seconds
ai-browser-worker-3 Up 10 seconds
ai-quota-tracker    Up 10 seconds
```

**All services running!** ✅

---

## Step 5: Create Your Account (2 minutes)

### Open Webapp

```bash
# Local:
open http://localhost:3000

# Remote server:
open http://YOUR_SERVER_IP:3000
```

### Sign Up

1. Click **"Don't have an account? Sign up"**
2. Enter email and password
3. Check your email for confirmation link
4. Click confirmation link
5. Return to webapp and sign in

**You're logged in!** 🎉

---

## Step 6: Add Your First AI Account (3 minutes)

### In the Webapp

1. Click **"+ Add Account"** button
2. Select provider (start with **DeepSeek** - it's unlimited!)
3. Enter the email you use for that provider
4. Click **"Add Account"**

The account will show as **"pending"** status.

### Complete Login (Browser Worker)

**Check browser worker logs:**

```bash
docker compose -f docker-compose.v2.yml logs -f browser-worker-1
```

You'll see the worker attempting to log in.

**For first-time setup, you may need to manually complete the login:**

#### Option A: Headless Mode (Automatic)

If the provider doesn't have 2FA, the worker will log in automatically using stored sessions.

#### Option B: Manual Login (For 2FA)

1. Stop headless mode:
```bash
# Edit .env
HEADLESS_MODE=false

# Restart workers
docker compose -f docker-compose.v2.yml restart browser-worker-1
```

2. Access the browser worker (if on server, use VNC):
```bash
# Install VNC on server
sudo apt install x11vnc xvfb
x11vnc -create -forever -nopw

# Connect with VNC client to YOUR_SERVER_IP:5900
```

3. Watch the browser automation and input 2FA codes when prompted

4. Once logged in, session is saved automatically

5. Re-enable headless mode:
```bash
# Edit .env
HEADLESS_MODE=true

# Restart
docker compose -f docker-compose.v2.yml restart browser-worker-1
```

**Account now shows "active"!** ✅

---

## Step 7: Generate API Key (2 minutes)

### Via Supabase SQL Editor

```sql
-- Generate a secure API key
SELECT 'aikey_' || replace(gen_random_uuid()::text, '-', '') as api_key;

-- Copy the generated key (you'll only see it once!)
-- Example: aikey_a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6

-- Get your user ID
SELECT id FROM auth.users WHERE email = 'your-email@example.com';

-- Insert the API key
INSERT INTO api_keys (
  user_id,
  name,
  key_hash,
  key_prefix
) VALUES (
  'YOUR-USER-ID-HERE',
  'My First API Key',
  encode(digest('YOUR-GENERATED-KEY-HERE', 'sha256'), 'hex'),
  substring('YOUR-GENERATED-KEY-HERE', 1, 12) || '...'
);
```

**Save your API key securely!** You won't be able to see it again.

**Note:** The API key format is `aikey_` followed by a random string.

---

## Step 8: Test the API (2 minutes)

### Submit a Chat Request

```bash
export API_KEY="YOUR-API-KEY-HERE"

curl -X POST http://localhost:3000/api/v1/chat \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "What is recursion? Explain in one sentence.",
    "provider": "auto"
  }'
```

**Response:**
```json
{
  "id": "req_a1b2c3d4",
  "status": "queued",
  "provider_used": "deepseek",
  "estimated_wait": 5,
  "quota_remaining": {
    "deepseek": 9999,
    "chatgpt": 60
  }
}
```

### Check Request Status

```bash
REQUEST_ID="req_a1b2c3d4"  # From previous response

curl http://localhost:3000/api/v1/status/$REQUEST_ID \
  -H "Authorization: Bearer $API_KEY"
```

**Response (after a few seconds):**
```json
{
  "id": "req_a1b2c3d4",
  "status": "completed",
  "provider_used": "deepseek",
  "response": "Recursion is when a function calls itself to solve a problem by breaking it down into smaller instances of the same problem.",
  "tokens_used": 42,
  "latency_ms": 2340
}
```

**It works!** 🚀

### Check Quotas

```bash
curl http://localhost:3000/api/v1/quotas \
  -H "Authorization: Bearer $API_KEY"
```

**Response:**
```json
{
  "providers": {
    "deepseek": {
      "daily": {
        "used": 1,
        "limit": 10000,
        "remaining": 9999
      },
      "status": "available"
    }
  },
  "total_accounts": 1,
  "active_accounts": 1
}
```

---

## Step 9: Monitor & Manage (Ongoing)

### Check Logs

```bash
# All services
docker compose -f docker-compose.v2.yml logs -f

# Specific service
docker compose -f docker-compose.v2.yml logs -f browser-worker-1
docker compose -f docker-compose.v2.yml logs -f quota-tracker
```

### Access Dashboard

Open http://localhost:3000 to:
- View real-time quota usage
- Add more accounts
- See request logs
- Manage API keys

### Add More Providers

Repeat Step 6 for:
- ChatGPT (60 msg/5hr per account)
- Claude (40 msg/day per account)
- Gemini (15 msg per account)

**Recommended:** Add 2-3 accounts per provider for rotation.

---

## Production Setup (Optional)

### Enable HTTPS

```bash
# Install Nginx
sudo apt install nginx certbot python3-certbot-nginx

# Create config
sudo nano /etc/nginx/sites-available/ai-orchestrator
```

```nginx
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
    }
}
```

```bash
# Enable site
sudo ln -s /etc/nginx/sites-available/ai-orchestrator /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx

# Get SSL
sudo certbot --nginx -d your-domain.com
```

### Configure Firewall

```bash
sudo ufw allow 22/tcp   # SSH
sudo ufw allow 80/tcp   # HTTP
sudo ufw allow 443/tcp  # HTTPS
sudo ufw enable
```

### Set Up Monitoring

```bash
# View resource usage
docker stats

# Set up alerts (webhook to Slack/Discord)
# Edit quota-tracker/src/index.ts
# Add webhook URL to sendAlert() function
```

---

## Common Issues

### Issue: Containers won't start

```bash
# Check logs
docker compose -f docker-compose.v2.yml logs

# Rebuild
docker compose -f docker-compose.v2.yml build --no-cache
docker compose -f docker-compose.v2.yml up -d
```

### Issue: "Session expired" errors

```bash
# Check browser worker logs
docker compose -f docker-compose.v2.yml logs browser-worker-1

# Re-login via webapp:
# 1. Delete account
# 2. Add account again
# 3. Complete login flow
```

### Issue: Quota not resetting

```bash
# Check quota tracker
docker compose -f docker-compose.v2.yml logs quota-tracker

# Manual reset (SQL)
UPDATE quotas SET daily_used = 0, reset_daily_at = NOW() + INTERVAL '1 day';
```

### Issue: API returning 401 Unauthorized

```bash
# Verify API key is correct
# Check key_hash in database matches
SELECT encode(digest('YOUR-API-KEY', 'sha256'), 'hex');

# Should match value in api_keys table
SELECT key_hash FROM api_keys;
```

---

## Next Steps

### Scale Up

```bash
# Edit docker-compose.v2.yml
# Increase worker count or concurrency
docker compose -f docker-compose.v2.yml up -d --scale browser-worker=5
```

### Add More Accounts

Add 5+ accounts per provider for maximum capacity:
- DeepSeek: 5 accounts = 50K+ requests/month
- ChatGPT: 5 accounts = 15K requests/month
- Claude: 5 accounts = 6K requests/month
- Gemini: 5 accounts = 2K requests/month

**Total: ~70K+ requests/month at $0 AI cost!**

### Integrate Into Your Apps

See `examples/` directory for:
- Python integration
- Node.js integration
- React integration
- Go integration

---

## Success Checklist

- [ ] Supabase project created
- [ ] Database schema deployed
- [ ] Realtime enabled
- [ ] Environment configured
- [ ] Docker services running
- [ ] Account created and logged in
- [ ] First AI account added
- [ ] API key generated
- [ ] Test request successful
- [ ] Quota dashboard working
- [ ] HTTPS enabled (production)
- [ ] Monitoring set up (production)

**All done!** You now have a fully functional AI CLI Orchestrator V2. 🎊

---

## Support

- **Documentation:** See `SYSTEM_ARCHITECTURE_V2_OAUTH.md`
- **Deployment:** See `DEPLOYMENT_GUIDE.md`
- **Issues:** GitHub Issues
- **Logs:** `docker compose logs -f`

**Estimated total time:** 25-30 minutes

**Welcome to AI CLI Orchestrator V2!** 🚀
