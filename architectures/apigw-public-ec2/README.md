## How to use?
1. Visit instance through public ip.
```
ssh -i ssh-chroma.pem ec2-user@{public-ip}
```
2. Visit chroma heartbeat.
```
curl {public-ip}:8000/api/v1/heartbeat
```
3. Call api via api gateway with api key.
    - GET `https://******.execute-api.eu-west-2.amazonaws.com/v1/api/v1/heartbeat`
    - Authorization Type: API Key
    - Key: x-api-key
    - Value: {api key}
4. Call api with curl.
```
curl --location --request GET 'https://*******.execute-api.eu-west-2.amazonaws.com/v1/api/v1/heartbeat' \
--header 'x-api-key: ****'
```
5. Call api with python requests.
```
headers = {"x-api-key": "****"}
response = requests.get('https://*****.execute-api.eu-west-2.amazonaws.com/v1/api/v1/heartbeat', headers=headers)
print(response.text)
```
6. Read Cloudwatch logs from API-Gateway-Execution-Logs_xxxxxx.
