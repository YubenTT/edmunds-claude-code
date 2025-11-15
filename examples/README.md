# AI CLI Orchestrator V2 - Example Integrations

This directory contains example clients in different programming languages showing how to integrate with the AI CLI Orchestrator V2 API.

---

## Available Examples

### 1. Python Client

**Location:** `python/client.py`

**Features:**
- Simple synchronous chat
- Asynchronous requests
- Batch processing
- Quota checking
- Full error handling

**Installation:**
```bash
cd python
pip install -r requirements.txt
```

**Usage:**
```python
from client import AIOrchestrator

client = AIOrchestrator(
    api_url="http://localhost:3001/api/v1",
    api_key="sk_live_abc123..."
)

# Simple chat
response = client.chat("What is recursion?")
print(response['text'])

# Batch processing
prompts = ["What is AI?", "What is ML?"]
results = client.batch_chat(prompts)
```

**Run example:**
```bash
export AI_API_KEY="sk_live_abc123..."
python client.py
```

---

### 2. Node.js Client

**Location:** `nodejs/client.js`

**Features:**
- Promise-based async/await
- Batch processing
- Quota checking
- ES6+ syntax

**Installation:**
```bash
cd nodejs
npm install
```

**Usage:**
```javascript
const AIOrchestrator = require('./client');

const client = new AIOrchestrator(
    'http://localhost:3001/api/v1',
    'sk_live_abc123...'
);

// Simple chat
const response = await client.chat('What is recursion?');
console.log(response.text);

// Batch processing
const prompts = ['What is AI?', 'What is ML?'];
const results = await client.batchChat(prompts);
```

**Run example:**
```bash
export AI_API_KEY="sk_live_abc123..."
node client.js
```

---

### 3. Bash Client

**Location:** `bash/client.sh`

**Features:**
- Simple command-line interface
- Uses curl and jq
- Quota checking
- Status polling

**Installation:**
```bash
# Requires curl and jq
sudo apt install curl jq  # Ubuntu/Debian
brew install curl jq      # macOS
```

**Usage:**
```bash
export AI_API_KEY="sk_live_abc123..."

# Simple chat
./client.sh chat "What is recursion?"

# Use specific provider
./client.sh chat "Explain AI" chatgpt

# Check quotas
./client.sh quotas

# Get request status
./client.sh status req_abc123
```

**Make executable:**
```bash
chmod +x client.sh
```

---

## Quick Start

1. **Set API key environment variable:**
```bash
export AI_API_KEY="your-api-key-here"
```

2. **Choose your language and run:**

**Python:**
```bash
cd python && python client.py
```

**Node.js:**
```bash
cd nodejs && node client.js
```

**Bash:**
```bash
cd bash && ./client.sh chat "Hello world"
```

---

## API Endpoints

All examples use these endpoints:

### POST /api/v1/chat
Submit a chat request.

**Request:**
```json
{
  "prompt": "What is recursion?",
  "provider": "auto",
  "priority": "normal"
}
```

**Response:**
```json
{
  "id": "req_abc123",
  "status": "queued",
  "provider_used": "chatgpt",
  "estimated_wait": 5
}
```

### GET /api/v1/status/{request_id}
Get request status.

**Response:**
```json
{
  "id": "req_abc123",
  "status": "completed",
  "response": "Recursion is when a function calls itself...",
  "tokens_used": 42,
  "latency_ms": 2340
}
```

### GET /api/v1/quotas
Get quota usage.

**Response:**
```json
{
  "providers": {
    "chatgpt": {
      "daily": { "used": 15, "limit": 60, "remaining": 45 }
    }
  }
}
```

---

## Common Patterns

### 1. Synchronous Chat (Wait for Response)

**Python:**
```python
response = client.chat("What is AI?")
```

**Node.js:**
```javascript
const response = await client.chat("What is AI?");
```

**Bash:**
```bash
./client.sh chat "What is AI?"
```

### 2. Asynchronous Chat (Don't Wait)

**Python:**
```python
request_id = client.chat_async("What is AI?")
# Do other work...
status = client.get_status(request_id)
```

**Node.js:**
```javascript
const requestId = await client.chatAsync("What is AI?");
// Do other work...
const status = await client.getStatus(requestId);
```

### 3. Batch Processing

**Python:**
```python
prompts = ["Q1?", "Q2?", "Q3?"]
results = client.batch_chat(prompts)
```

**Node.js:**
```javascript
const prompts = ["Q1?", "Q2?", "Q3?"];
const results = await client.batchChat(prompts);
```

### 4. Quota Checking

**Python:**
```python
quotas = client.get_quotas()
for provider, data in quotas['providers'].items():
    print(f"{provider}: {data['daily']['remaining']} remaining")
```

**Node.js:**
```javascript
const quotas = await client.getQuotas();
for (const [provider, data] of Object.entries(quotas.providers)) {
    console.log(`${provider}: ${data.daily.remaining} remaining`);
}
```

**Bash:**
```bash
./client.sh quotas
```

---

## Error Handling

All clients include error handling for:
- ✅ Invalid API key (401 Unauthorized)
- ✅ Rate limit exceeded (429 Too Many Requests)
- ✅ Request timeout
- ✅ Request failure
- ✅ Network errors

**Example (Python):**
```python
try:
    response = client.chat("What is AI?")
    print(response['text'])
except Exception as e:
    print(f"Error: {e}")
```

---

## Rate Limiting

Default limits:
- **100 requests per minute** per API key
- **10,000 requests per day** per API key

**Recommendation:** Add delays between batch requests:

**Python:**
```python
for i, prompt in enumerate(prompts):
    if i > 0 and i % 10 == 0:
        time.sleep(1)  # Pause after every 10 requests
    client.chat_async(prompt)
```

---

## Best Practices

1. **Use environment variables for API keys**
   ```bash
   export AI_API_KEY="sk_live_..."
   ```

2. **Handle errors gracefully**
   - Implement retry logic for network errors
   - Check quota before large batches
   - Use try/catch blocks

3. **Monitor quotas**
   - Check quotas periodically
   - Alert when approaching limits
   - Implement fallback logic

4. **Choose the right provider**
   - Use `"auto"` for intelligent selection
   - Use specific provider when needed
   - DeepSeek for unlimited free usage

5. **Optimize batch processing**
   - Limit concurrent requests
   - Use async for large batches
   - Monitor response times

---

## Integration Patterns

### Pattern 1: AI-Powered Chatbot

```python
# chatbot.py
from client import AIOrchestrator

client = AIOrchestrator(api_url, api_key)

def chatbot_loop():
    while True:
        user_input = input("You: ")
        if user_input.lower() == 'exit':
            break

        response = client.chat(user_input, provider="auto")
        print(f"AI: {response['text']}")
```

### Pattern 2: Document Summarizer

```python
# summarizer.py
def summarize_documents(documents):
    prompts = [f"Summarize: {doc}" for doc in documents]
    return client.batch_chat(prompts, provider="deepseek")

docs = ["Article 1...", "Article 2...", "Article 3..."]
summaries = summarize_documents(docs)
```

### Pattern 3: Multi-Provider Fallback

```python
# fallback.py
def chat_with_fallback(prompt):
    providers = ["deepseek", "gemini", "chatgpt", "claude"]

    for provider in providers:
        try:
            return client.chat(prompt, provider=provider)
        except Exception as e:
            print(f"{provider} failed: {e}")
            continue

    raise Exception("All providers failed")
```

---

## Troubleshooting

### Issue: 401 Unauthorized
**Cause:** Invalid API key
**Solution:** Check your API key is correct and not revoked

### Issue: 429 Rate Limit Exceeded
**Cause:** Too many requests
**Solution:** Add delays between requests or upgrade limits

### Issue: Request timeout
**Cause:** Provider is slow or quota exceeded
**Solution:** Increase `max_wait` parameter or check quotas

### Issue: No response
**Cause:** No active accounts or all quotas exceeded
**Solution:** Add more accounts or wait for quota reset

---

## Support

- **Documentation:** See main README_V2.md
- **API Docs:** SYSTEM_ARCHITECTURE_V2_OAUTH.md
- **Issues:** GitHub Issues

---

## License

MIT License - See LICENSE file
