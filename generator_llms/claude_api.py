# import json
# import boto3
# import time
# import os

# # with open('generator_llms/aws_access.key', 'r') as f:
# #     AWS_ACCESS_KEY_ID = f.read().strip()

# # with open('generator_llms/claude_api_aws.key', 'r') as f:
# #     AWS_SECRET_ACCESS_KEY = f.read().strip()

# with open('generator_llms/claude_api_aws.key', 'r') as f:
#     AWS_SECRET_ACCESS_KEY = f.read().strip()
# os.environ['AWS_BEARER_TOKEN_BEDROCK'] = AWS_SECRET_ACCESS_KEY

# AWS_DEFAULT_REGION = "us-west-2"
# # AWS_DEFAULT_REGION = "ap-southeast-2"


# boto3_client = boto3.client("bedrock-runtime",
#     region_name=AWS_DEFAULT_REGION, 
#     # aws_access_key_id=AWS_ACCESS_KEY_ID, 
#     # aws_secret_access_key=AWS_SECRET_ACCESS_KEY
# )


# # model="claude-3-haiku-20240307"
# BEDROCK_MODEL_NAME_MAP = {
#     "claude": "anthropic.claude-v2:1",  # default to sonnet
#     "haiku": "anthropic.claude-3-haiku-20240307-v1:0",
#     "sonnet": "anthropic.claude-3-5-sonnet-20240620-v1:0",
#     "opus": "anthropic.claude-3-opus-20240229-v1:0"
# }


# def get_claude_response(prompt, max_tokens=500, temperature=0, tools=None, tool_choice=None, llm="haiku"):
#     model = BEDROCK_MODEL_NAME_MAP.get(llm)
#     if model is None:
#         raise ValueError(f"Unknown LLM: {llm}")
#     request_body = {
#         "anthropic_version": "bedrock-2023-05-31",    
#         "max_tokens": max_tokens,
#         "messages": [
#             {
#                 "role": "user",
#                 "content": [
#                     { "type": "text", "text": prompt}
#                 ]
#             }
#         ],
#         "temperature": temperature,
#     }
#     if tools:
#         request_body["tools"] = tools
#     if tool_choice:
#         request_body["tool_choice"] = tool_choice

#     request_body = json.dumps(request_body)

#     response = boto3_client.invoke_model(
#         body=request_body,
#         modelId=model
#     )
#     response_body = json.loads(response.get('body').read())
#     return response_body['content'][0]['text']


# def main():
#     prompt = "Hi"
#     response = get_claude_response(prompt, max_tokens=100)
#     print("Response:", response)


# if __name__ == "__main__":
#     main()


import os
from openai import OpenAI
import time

with open("generator_llms/ali_api.key", "r") as f:
    api_key = f.read().strip()

client = OpenAI(
    # If environment variables are not configured, replace the following line with: api_key="sk-xxx",
    api_key=api_key,
    base_url="https://dashscope.aliyuncs.com/compatible-mode/v1",
)


def get_claude_response(prompt, max_tokens=500, max_retries=3) -> str:
    for attempt in range(max_retries):
        try:
            completion = client.chat.completions.create(
                model="qwen3-max-preview", # Use Qwen3-max-preview. You can change the model name as needed. Model list: https://www.alibabacloud.com/help/en/model-studio/getting-started/models
                messages=[
                    {'role': 'system', 'content': 'You are a helpful assistant.'},
                    {'role': 'user', 'content': prompt}],
                max_tokens=max_tokens,
            )
            return completion.choices[0].message.content
        except Exception as e:
            print(f"Error generating answer (attempt {attempt + 1}/{max_retries}): {str(e)}")
            if attempt < max_retries - 1:
                time.sleep(1)
            else:
                raise Exception(f"Failed to generate answer after {max_retries} attempts: {str(e)}")


def main():
    prompt = "Hi"
    response = get_claude_response(prompt, max_tokens=100)
    print("Response:", response)


if __name__ == "__main__":
    main()
