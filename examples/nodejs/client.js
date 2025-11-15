/**
 * AI CLI Orchestrator V2 - Node.js Client Example
 *
 * Simple Node.js/JavaScript client for the AI CLI Orchestrator V2 API.
 */

const axios = require('axios');

class AIOrchestrator {
  /**
   * Initialize the client
   * @param {string} apiUrl - Base URL of the API
   * @param {string} apiKey - Your API key
   */
  constructor(apiUrl, apiKey) {
    this.apiUrl = apiUrl.replace(/\/$/, '');
    this.apiKey = apiKey;

    this.client = axios.create({
      baseURL: this.apiUrl,
      headers: {
        'Authorization': `Bearer ${apiKey}`,
        'Content-Type': 'application/json'
      }
    });
  }

  /**
   * Send a chat request and wait for response
   * @param {string} prompt - The prompt to send
   * @param {object} options - Options (provider, priority, maxWait, pollInterval)
   * @returns {Promise<object>} Response with text, provider, tokens, latency_ms
   */
  async chat(prompt, options = {}) {
    const {
      provider = 'auto',
      priority = 'normal',
      maxWait = 120,
      pollInterval = 1000
    } = options;

    // Submit request
    const { data } = await this.client.post('/chat', {
      prompt,
      provider,
      priority
    });

    const requestId = data.id;

    // Poll for result
    const startTime = Date.now();
    while (Date.now() - startTime < maxWait * 1000) {
      const status = await this.getStatus(requestId);

      if (status.status === 'completed') {
        return {
          text: status.response,
          provider: status.provider_used,
          tokens: status.tokens_used,
          latency_ms: status.latency_ms
        };
      }

      if (status.status === 'failed') {
        throw new Error(`Request failed: ${status.error_message || 'Unknown error'}`);
      }

      await new Promise(resolve => setTimeout(resolve, pollInterval));
    }

    throw new Error(`Request timed out after ${maxWait} seconds`);
  }

  /**
   * Submit a chat request without waiting
   * @param {string} prompt - The prompt to send
   * @param {object} options - Options (provider, priority)
   * @returns {Promise<string>} Request ID
   */
  async chatAsync(prompt, options = {}) {
    const {
      provider = 'auto',
      priority = 'normal'
    } = options;

    const { data } = await this.client.post('/chat', {
      prompt,
      provider,
      priority
    });

    return data.id;
  }

  /**
   * Get status of a request
   * @param {string} requestId - The request ID
   * @returns {Promise<object>} Request status
   */
  async getStatus(requestId) {
    const { data } = await this.client.get(`/status/${requestId}`);
    return data;
  }

  /**
   * Get current quota usage
   * @returns {Promise<object>} Quota information
   */
  async getQuotas() {
    const { data } = await this.client.get('/quotas');
    return data;
  }

  /**
   * Process multiple prompts in batch
   * @param {string[]} prompts - Array of prompts
   * @param {object} options - Options (provider, maxConcurrent)
   * @returns {Promise<string[]>} Array of responses
   */
  async batchChat(prompts, options = {}) {
    const {
      provider = 'auto',
      maxConcurrent = 10
    } = options;

    // Submit all requests
    const requestIds = [];
    for (let i = 0; i < prompts.length; i++) {
      if (i > 0 && i % maxConcurrent === 0) {
        await new Promise(resolve => setTimeout(resolve, 1000));
      }

      const requestId = await this.chatAsync(prompts[i], { provider });
      requestIds.push(requestId);
    }

    // Collect results
    const results = [];
    for (const requestId of requestIds) {
      while (true) {
        const status = await this.getStatus(requestId);

        if (status.status === 'completed') {
          results.push(status.response);
          break;
        } else if (status.status === 'failed') {
          results.push(`ERROR: ${status.error_message || 'Unknown'}`);
          break;
        }

        await new Promise(resolve => setTimeout(resolve, 1000));
      }
    }

    return results;
  }
}

// Example usage
async function main() {
  const client = new AIOrchestrator(
    process.env.AI_API_URL || 'http://localhost:3001/api/v1',
    process.env.AI_API_KEY || 'your-api-key-here'
  );

  try {
    // Example 1: Simple chat
    console.log('Example 1: Simple chat');
    const response = await client.chat('What is recursion? Explain in one sentence.');
    console.log(`Response: ${response.text}`);
    console.log(`Provider: ${response.provider}`);
    console.log(`Tokens: ${response.tokens}`);
    console.log(`Latency: ${response.latency_ms}ms`);
    console.log();

    // Example 2: Check quotas
    console.log('Example 2: Check quotas');
    const quotas = await client.getQuotas();
    for (const [provider, data] of Object.entries(quotas.providers)) {
      const { daily } = data;
      console.log(`${provider}: ${daily.used}/${daily.limit} used (${daily.remaining} remaining)`);
    }
    console.log();

    // Example 3: Batch processing
    console.log('Example 3: Batch processing');
    const prompts = [
      'What is AI?',
      'What is ML?',
      'What is Deep Learning?'
    ];
    const results = await client.batchChat(prompts, { provider: 'deepseek' });
    results.forEach((result, i) => {
      console.log(`Q${i+1}: ${prompts[i]}`);
      console.log(`A${i+1}: ${result}`);
      console.log();
    });

  } catch (error) {
    console.error('Error:', error.message);
    process.exit(1);
  }
}

// Run if called directly
if (require.main === module) {
  main();
}

module.exports = AIOrchestrator;
