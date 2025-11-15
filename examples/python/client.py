"""
AI CLI Orchestrator V2 - Python Client Example

Simple Python client for the AI CLI Orchestrator V2 API.
"""

import requests
import time
from typing import Optional, Dict, Any


class AIOrchestrator:
    """
    Python client for AI CLI Orchestrator V2 API.

    Usage:
        client = AIOrchestrator(
            api_url="http://localhost:3001/api/v1",
            api_key="sk_live_abc123..."
        )

        response = client.chat("What is recursion?")
        print(response)
    """

    def __init__(self, api_url: str, api_key: str):
        """
        Initialize the client.

        Args:
            api_url: Base URL of the API (e.g., http://localhost:3001/api/v1)
            api_key: Your API key
        """
        self.api_url = api_url.rstrip('/')
        self.api_key = api_key
        self.session = requests.Session()
        self.session.headers.update({
            'Authorization': f'Bearer {api_key}',
            'Content-Type': 'application/json'
        })

    def chat(
        self,
        prompt: str,
        provider: str = "auto",
        priority: str = "normal",
        max_wait: int = 120,
        poll_interval: float = 1.0
    ) -> Dict[str, Any]:
        """
        Send a chat request and wait for response.

        Args:
            prompt: The prompt to send to the AI
            provider: Provider to use ('auto', 'chatgpt', 'claude', 'gemini', 'deepseek')
            priority: Request priority ('high', 'normal', 'low')
            max_wait: Maximum seconds to wait for response
            poll_interval: Seconds between status checks

        Returns:
            dict: Response with 'text', 'provider', 'tokens', 'latency_ms'

        Raises:
            Exception: If request fails or times out
        """
        # Submit request
        response = self.session.post(
            f'{self.api_url}/chat',
            json={
                'prompt': prompt,
                'provider': provider,
                'priority': priority
            }
        )

        if response.status_code != 202:
            raise Exception(f'Failed to submit request: {response.text}')

        data = response.json()
        request_id = data['id']

        # Poll for result
        start_time = time.time()
        while time.time() - start_time < max_wait:
            status = self.get_status(request_id)

            if status['status'] == 'completed':
                return {
                    'text': status['response'],
                    'provider': status['provider_used'],
                    'tokens': status['tokens_used'],
                    'latency_ms': status['latency_ms']
                }

            if status['status'] == 'failed':
                raise Exception(f'Request failed: {status.get("error_message", "Unknown error")}')

            time.sleep(poll_interval)

        raise Exception(f'Request timed out after {max_wait} seconds')

    def chat_async(
        self,
        prompt: str,
        provider: str = "auto",
        priority: str = "normal"
    ) -> str:
        """
        Submit a chat request without waiting for response.

        Returns:
            str: Request ID to check status later
        """
        response = self.session.post(
            f'{self.api_url}/chat',
            json={
                'prompt': prompt,
                'provider': provider,
                'priority': priority
            }
        )

        if response.status_code != 202:
            raise Exception(f'Failed to submit request: {response.text}')

        return response.json()['id']

    def get_status(self, request_id: str) -> Dict[str, Any]:
        """
        Get status of a request.

        Args:
            request_id: The request ID

        Returns:
            dict: Request status information
        """
        response = self.session.get(f'{self.api_url}/status/{request_id}')

        if response.status_code != 200:
            raise Exception(f'Failed to get status: {response.text}')

        return response.json()

    def get_quotas(self) -> Dict[str, Any]:
        """
        Get current quota usage for all providers.

        Returns:
            dict: Quota information by provider
        """
        response = self.session.get(f'{self.api_url}/quotas')

        if response.status_code != 200:
            raise Exception(f'Failed to get quotas: {response.text}')

        return response.json()

    def batch_chat(
        self,
        prompts: list,
        provider: str = "auto",
        max_concurrent: int = 10
    ) -> list:
        """
        Process multiple prompts in batch.

        Args:
            prompts: List of prompts to process
            provider: Provider to use
            max_concurrent: Maximum concurrent requests

        Returns:
            list: List of responses in same order as prompts
        """
        # Submit all requests
        request_ids = []
        for i, prompt in enumerate(prompts):
            if i > 0 and i % max_concurrent == 0:
                time.sleep(1)  # Rate limiting

            request_id = self.chat_async(prompt, provider)
            request_ids.append(request_id)

        # Collect results
        results = []
        for request_id in request_ids:
            while True:
                status = self.get_status(request_id)
                if status['status'] == 'completed':
                    results.append(status['response'])
                    break
                elif status['status'] == 'failed':
                    results.append(f"ERROR: {status.get('error_message', 'Unknown')}")
                    break
                time.sleep(1)

        return results


# Example usage
if __name__ == '__main__':
    import os

    # Initialize client
    client = AIOrchestrator(
        api_url=os.getenv('AI_API_URL', 'http://localhost:3001/api/v1'),
        api_key=os.getenv('AI_API_KEY', 'your-api-key-here')
    )

    # Example 1: Simple chat
    print("Example 1: Simple chat")
    response = client.chat("What is recursion? Explain in one sentence.")
    print(f"Response: {response['text']}")
    print(f"Provider: {response['provider']}")
    print(f"Tokens: {response['tokens']}")
    print(f"Latency: {response['latency_ms']}ms")
    print()

    # Example 2: Check quotas
    print("Example 2: Check quotas")
    quotas = client.get_quotas()
    for provider, data in quotas['providers'].items():
        daily = data['daily']
        print(f"{provider}: {daily['used']}/{daily['limit']} used ({daily['remaining']} remaining)")
    print()

    # Example 3: Batch processing
    print("Example 3: Batch processing")
    prompts = [
        "What is AI?",
        "What is ML?",
        "What is Deep Learning?"
    ]
    results = client.batch_chat(prompts, provider="deepseek")
    for i, result in enumerate(results):
        print(f"Q{i+1}: {prompts[i]}")
        print(f"A{i+1}: {result}")
        print()
