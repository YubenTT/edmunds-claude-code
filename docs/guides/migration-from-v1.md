# Migrating from V1 to V2

**AI CLI Orchestrator: V1 → V2 Migration Guide**

This guide helps you migrate from the V1 (API-only) system to the V2 (browser automation + OAuth) system.

---

## Should You Migrate?

### Reasons to Migrate

✅ **10x more capacity** - 150K vs 10K requests/month
✅ **Lower cost** - $13-30 vs $0-43/month
✅ **Better reliability** - Multi-account rotation
✅ **Real-time monitoring** - Live quota tracking
✅ **Production ready** - Full Docker deployment
✅ **External API** - Integrate with any application

### Reasons to Stay on V1

❌ Simpler setup (no browser automation)
❌ API keys only (no session management)
❌ Lower infrastructure requirements

**Recommendation:** Migrate to V2 for production use. V1 is good for simple CLI usage.

---

## Migration Comparison

| Feature | V1 | V2 | Migration Effort |
|---------|----|----|------------------|
| **Setup** | CLI tool | Full system | 🔴 High |
| **API Keys** | Manual setup | Webapp management | 🟢 Easy |
| **Accounts** | N/A | Browser automation | 🟡 Medium |
| **Deployment** | Local only | Docker + Cloud | 🔴 High |
| **Monitoring** | None | Real-time | 🟢 Easy |
| **Integration** | Direct CLI | REST API | 🟡 Medium |

---

## Migration Path

### Option A: Clean Migration (Recommended)

Start fresh with V2 and deprecate V1.

**Steps:**
1. Deploy V2 system (see DEPLOYMENT_GUIDE.md)
2. Add AI accounts in V2 webapp
3. Generate API keys
4. Update applications to use V2 API
5. Test thoroughly
6. Deprecate V1

**Time:** 2-4 hours
**Risk:** Low (both systems can run in parallel)

### Option B: Gradual Migration

Run both systems simultaneously and migrate slowly.

**Steps:**
1. Deploy V2 alongside V1
2. Route new requests to V2
3. Keep V1 for critical workloads
4. Monitor V2 performance
5. Gradually shift traffic
6. Decommission V1

**Time:** 1-2 weeks
**Risk:** Very low (fallback available)

### Option C: Hybrid Approach

Use V2 for web-based providers, V1 for API-only providers.

**Steps:**
1. Deploy V2
2. Configure V2 for ChatGPT, Claude, Gemini, DeepSeek (web)
3. Keep V1 for Gemini API, Groq, etc.
4. Route requests based on provider type

**Time:** 2-3 hours
**Risk:** Medium (managing two systems)

---

## Step-by-Step Migration

### Phase 1: Preparation (30 minutes)

#### 1. Document V1 Configuration

```bash
# Export V1 API keys
cd ai-cli-orchestrator-v1
cat .env > v1-config-backup.txt

# List all configured providers
# (manual documentation)
```

#### 2. Note V1 Usage Patterns

- Which providers do you use most?
- What's your daily request volume?
- What are your peak usage times?
- Any specific model preferences?

#### 3. Read V2 Documentation

- [ ] QUICKSTART_V2.md
- [ ] DEPLOYMENT_GUIDE.md
- [ ] SYSTEM_ARCHITECTURE_V2_OAUTH.md

---

### Phase 2: Deploy V2 (1-2 hours)

Follow complete deployment guide:

```bash
# 1. Create Supabase project
# Visit: https://app.supabase.com

# 2. Clone V2
git clone https://github.com/your-repo/ai-cli-orchestrator.git
cd ai-cli-orchestrator

# 3. Run deployment script
./deploy-v2.sh

# 4. Follow prompts
```

See **DEPLOYMENT_GUIDE.md** for detailed steps.

---

### Phase 3: Configure Accounts (30-60 minutes)

#### Map V1 Providers to V2

| V1 Provider | V2 Equivalent | Migration |
|-------------|---------------|-----------|
| OpenAI API | ChatGPT Web | ✅ Add account in webapp |
| Anthropic API | Claude Web | ✅ Add account in webapp |
| Gemini API | Gemini Web | ✅ Add account in webapp |
| DeepSeek API | DeepSeek Web | ✅ Add account in webapp |
| Groq | (Keep V1) | ⚠️ No web version |
| Others | (Keep V1) | ⚠️ Evaluate case-by-case |

#### Add Accounts in V2

```bash
# 1. Access webapp
open http://localhost:3000

# 2. Sign up / Log in

# 3. Click "Add Account"

# 4. For each provider:
#    - Select provider
#    - Enter email
#    - Complete login (manual or automated)

# 5. Verify accounts are "active"
```

**Recommendation:** Add 2-3 accounts per provider for rotation.

---

### Phase 4: Update Applications (1-2 hours)

#### A. If Using V1 CLI Directly

**Before (V1):**
```bash
# Direct CLI usage
ai-cli ask chatgpt "What is AI?"
```

**After (V2):**
```bash
# Use bash client
export AI_API_KEY="sk_live_abc123..."
./examples/bash/client.sh chat "What is AI?"

# Or via API
curl -X POST http://localhost:3001/api/v1/chat \
  -H "Authorization: Bearer $AI_API_KEY" \
  -d '{"prompt": "What is AI?"}'
```

#### B. If Using V1 Programmatically

**Before (V1 - Python):**
```python
# Direct API calls
import anthropic
client = anthropic.Anthropic(api_key="sk-ant-...")
response = client.messages.create(
    model="claude-3-sonnet-20240229",
    messages=[{"role": "user", "content": "Hello"}]
)
```

**After (V2 - Python):**
```python
# Use V2 client
from examples.python.client import AIOrchestrator

client = AIOrchestrator(
    api_url="http://localhost:3001/api/v1",
    api_key="sk_live_abc123..."
)

response = client.chat("Hello", provider="claude")
print(response['text'])
```

#### C. Update Environment Variables

**Before (V1):**
```env
ANTHROPIC_API_KEY=sk-ant-...
OPENAI_API_KEY=sk-...
GEMINI_API_KEY=...
```

**After (V2):**
```env
AI_API_URL=http://localhost:3001/api/v1
AI_API_KEY=sk_live_abc123...
```

---

### Phase 5: Test & Validate (30 minutes)

#### Test Checklist

```bash
# 1. Simple chat request
export AI_API_KEY="sk_live_abc123..."
curl -X POST http://localhost:3001/api/v1/chat \
  -H "Authorization: Bearer $AI_API_KEY" \
  -d '{"prompt": "Test message", "provider": "auto"}'

# 2. Check quotas
curl http://localhost:3001/api/v1/quotas \
  -H "Authorization: Bearer $AI_API_KEY"

# 3. Test each provider
for provider in chatgpt claude gemini deepseek; do
  echo "Testing $provider..."
  curl -X POST http://localhost:3001/api/v1/chat \
    -H "Authorization: Bearer $AI_API_KEY" \
    -d "{\"prompt\": \"Hello from $provider\", \"provider\": \"$provider\"}"
done

# 4. Load test (optional)
# Send 100 requests
for i in {1..100}; do
  curl -X POST http://localhost:3001/api/v1/chat \
    -H "Authorization: Bearer $AI_API_KEY" \
    -d '{"prompt": "Test '$i'"}' &
done
wait
```

#### Verify V2 Features

- [ ] Webapp accessible at http://localhost:3000
- [ ] All accounts show "active" status
- [ ] Quotas updating in real-time
- [ ] Request logs appearing
- [ ] Browser workers processing requests
- [ ] Quota tracker resetting daily limits

---

### Phase 6: Migrate Traffic (Gradual)

#### Week 1: 10% Traffic

```python
# Route 10% of requests to V2
import random

def route_request(prompt):
    if random.random() < 0.1:
        # V2
        return v2_client.chat(prompt)
    else:
        # V1
        return v1_client.chat(prompt)
```

#### Week 2: 50% Traffic

```python
# Route 50% of requests to V2
if random.random() < 0.5:
    return v2_client.chat(prompt)
else:
    return v1_client.chat(prompt)
```

#### Week 3: 100% Traffic

```python
# All traffic to V2
return v2_client.chat(prompt)
```

#### Monitor During Migration

```bash
# V2 metrics
docker compose -f docker-compose.v2.yml logs -f quota-tracker

# V2 status
curl http://localhost:3001/api/v1/quotas

# Error rates
docker compose -f docker-compose.v2.yml logs | grep ERROR
```

---

### Phase 7: Decommission V1

Once V2 is stable (2-4 weeks):

```bash
# 1. Stop V1
# (if running as service, stop it)

# 2. Backup V1 data
tar -czf v1-backup.tar.gz ai-cli-orchestrator-v1/

# 3. Archive V1 configs
mv v1-config-backup.txt archives/

# 4. Update documentation
# Remove V1 references

# 5. Celebrate! 🎉
```

---

## Configuration Mapping

### API Keys

**V1:**
```env
ANTHROPIC_API_KEY=sk-ant-...
OPENAI_API_KEY=sk-...
GEMINI_API_KEY=...
DEEPSEEK_API_KEY=...
GROQ_API_KEY=...
```

**V2:**
```env
# No provider API keys needed!
# (unless using hybrid approach)

# Only V2 system credentials:
SUPABASE_URL=...
SUPABASE_ANON_KEY=...
SUPABASE_SERVICE_KEY=...

# User API key (generated in webapp)
AI_API_KEY=sk_live_...
```

### Quota Limits

**V1:**
- Manual tracking
- No automatic reset
- No rotation

**V2:**
- Automatic tracking
- Daily/monthly reset
- Multi-account rotation

### Request Format

**V1 (direct API):**
```python
# Provider-specific code
anthropic_client.messages.create(...)
openai_client.chat.completions.create(...)
```

**V2 (unified API):**
```python
# Provider-agnostic
client.chat(prompt, provider="auto")
```

---

## Troubleshooting Migration Issues

### Issue: V2 not receiving requests

**Check:**
```bash
# Is API running?
docker compose -f docker-compose.v2.yml ps

# Can you access webapp?
curl http://localhost:3000

# Check logs
docker compose -f docker-compose.v2.yml logs api-gateway
```

### Issue: Accounts stuck in "pending"

**Solution:**
```bash
# Check browser worker logs
docker compose -f docker-compose.v2.yml logs -f browser-worker-1

# May need manual login (see QUICKSTART_V2.md Step 6)
```

### Issue: High latency

**Causes:**
- Too few browser workers
- Quota exceeded
- Provider throttling

**Solutions:**
```bash
# Scale workers
docker compose -f docker-compose.v2.yml up -d --scale browser-worker=5

# Check quotas
curl http://localhost:3001/api/v1/quotas
```

### Issue: Sessions expiring frequently

**Solution:**
```bash
# Check session expiration
docker compose -f docker-compose.v2.yml logs quota-tracker | grep "Session expiring"

# May need to re-login accounts periodically
```

---

## Rollback Plan

If V2 doesn't work, rollback to V1:

```bash
# 1. Stop V2
docker compose -f docker-compose.v2.yml down

# 2. Restart V1
cd ../ai-cli-orchestrator-v1
# (restart V1 services)

# 3. Update applications to use V1

# 4. Investigate V2 issues

# 5. Try again when ready
```

**Recommendation:** Keep V1 running for 1-2 weeks during migration.

---

## Migration Checklist

### Pre-Migration
- [ ] Document V1 configuration
- [ ] Note usage patterns
- [ ] Read V2 documentation
- [ ] Plan migration timeline

### Deployment
- [ ] Create Supabase project
- [ ] Deploy V2 system
- [ ] Verify all containers running
- [ ] Access webapp successfully

### Configuration
- [ ] Add AI provider accounts
- [ ] Complete login for each account
- [ ] Verify accounts "active"
- [ ] Generate API keys
- [ ] Configure environment variables

### Testing
- [ ] Test simple chat request
- [ ] Test each provider
- [ ] Check quota tracking
- [ ] Verify real-time updates
- [ ] Load test (optional)

### Migration
- [ ] Update application code
- [ ] Route test traffic to V2
- [ ] Monitor error rates
- [ ] Gradually increase traffic
- [ ] Full cutover to V2

### Cleanup
- [ ] Decommission V1 (after 2-4 weeks)
- [ ] Archive V1 data
- [ ] Update documentation
- [ ] Remove V1 dependencies

---

## FAQ

### Q: Can I run V1 and V2 simultaneously?
**A:** Yes! They are completely independent. This is recommended during migration.

### Q: Do I need to migrate all providers?
**A:** No. You can use V2 for web-based providers and keep V1 for API-only providers.

### Q: What happens to my V1 data?
**A:** V1 data is not migrated. V2 is a fresh start with new database.

### Q: Is V2 compatible with V1 CLI?
**A:** No. V2 uses a REST API. You'll need to update your code (see examples/).

### Q: Can I export V1 quota history?
**A:** V1 doesn't track quota history. V2 has comprehensive usage logging.

### Q: How long does migration take?
**A:** Clean migration: 2-4 hours. Gradual migration: 1-2 weeks.

### Q: What if I only have one account per provider?
**A:** That's fine! But add 2-3 accounts per provider for better availability.

### Q: Does V2 support the same models as V1?
**A:** V2 uses web interfaces, so you get whatever models are available on the web (usually the latest).

---

## Support

- **Documentation:** DEPLOYMENT_GUIDE.md, QUICKSTART_V2.md
- **Architecture:** SYSTEM_ARCHITECTURE_V2_OAUTH.md
- **Examples:** examples/README.md
- **Issues:** GitHub Issues

---

## Summary

**Migration Process:**
1. ✅ Deploy V2 (1-2 hours)
2. ✅ Add accounts (30-60 minutes)
3. ✅ Update applications (1-2 hours)
4. ✅ Test thoroughly (30 minutes)
5. ✅ Migrate traffic gradually (1-2 weeks)
6. ✅ Decommission V1 (after 2-4 weeks)

**Total Time:** 4-8 hours active work + 1-2 weeks monitoring

**Result:** 10x capacity, lower cost, production-ready system!

**Welcome to V2!** 🚀
