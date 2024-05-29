import requests
import json

# Read the request.ql file
with open("request.ql", "r") as f:
    request_body = f.read()

# Set the headers
headers = {
    "Accept": "*/*",
    "Content-Type": "application/json",
    "Origin": "https://create.microsoft.com",
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36",
}

# Send the POST request
response = requests.post(
    "https://create.microsoft.com/api/graphql", headers=headers, data=request_body
)

# Handle the response
if response.status_code == 200:
    print("Success! Response:", response.json())
else:
    print("Error:", response.status_code, response.text)
