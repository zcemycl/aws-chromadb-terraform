# aws-chromadb-terraform
The repository to deploy chromadb via terraform into aws cloud infrastructure.

|Architecture 3|Architecture 4|
|---|---|
|![diagram](resources/apigw-nlb-ec2.png)|![diagram](resources/apigw-nlb-ecs.png)|

## Architectures
1. Vanilla public ec2 instance [[code]](architectures/vanilla-ec2)
    - Translated from the cloudformation template [here](https://s3.amazonaws.com/public.trychroma.com/cloudformation/latest/chroma.cf.json) to terraform.
2. Public ec2 instance with API gateway [[code]](architectures/apigw-public-ec2/)
    - Modified from the youtube video [How to run a Chroma Vector Database locally and on AWS! | EASY MODE](https://www.youtube.com/watch?v=xRIEKjOosaM)
    - Additional cloudwatch to view api gateway deployment.
3. (RECOMMENDED) Private ec2 instance with Network Load Balancer and API Gateway [[code]](architectures/apigw-nlb-ec2)
    - Modeified from the youtube video [Deploy a PRIVATE Chroma Vector DB to AWS | Step by step tutorial | Part 2](https://www.youtube.com/watch?v=rD3G3hbAawE&t=27s)
    - Additional cloudwatch to view api gateway deployment.
    - Additional public ec2 to view docker logs within private ec2.
4. (RECOMMENDED) Private ecs fargate with Network Load Balancer, EFS and API Gateway [[code]](architectures/apigw-nlb-ecs)
    - Fargate to manage docker containers.
    - Elastic File System for persistent volume of docker.
    - Cloudwatch Logs to store api gateway deployment messages and docker logs.

## How to deploy?
```bash
# change to another architecture directory
cd architectures/apigw-nlb-ecs
terraform init
terraform plan
terraform apply -auto-approve
```

## How to debug?
1. Visit chroma instance (architecture 3) through backdoor instance.
```bash
ssh -i ssh-chroma.pem ec2-user@{public-backdoor-ip}
ssh -i ssh-chroma.pem ec2-user@{private-chroma-ip}
```
2. Inside chroma instance, test chroma heartbeat.
```bash
curl 0.0.0.0:8000/api/v1/heartbeat
docker ps
docker logs {docker-id}
```
3. Call api via api gateway with api key in Postman.
    - GET `https://******.execute-api.eu-west-2.amazonaws.com/v1/api/v1/heartbeat`
    - Authorization Type: API Key
    - Key: x-api-key
    - Value: {api key}
4. Call api with curl.
```bash
curl --location --request GET 'https://*******.execute-api.eu-west-2.amazonaws.com/v1/api/v1/heartbeat' \
--header 'x-api-key: ****'
```
5. Call api with python requests.
```python
import requests
headers = {"x-api-key": "****"}
response = requests.get('https://*****.execute-api.eu-west-2.amazonaws.com/v1/api/v1/heartbeat',
    headers=headers)
print(response.text)
```
6. Read Cloudwatch logs from API-Gateway-Execution-Logs_xxxxxx.
7. Python sdk from chroma-core
```python
import chromadb

client = chromadb.HttpClient(
    host="xxxxxx.execute-api.eu-west-2.amazonaws.com/dev", # don't include https
    ssl=True,
    port="",
    headers={
        "X-Api-Key": "xxxxx"
    }
)
print("Heartbeat: ", client.heartbeat())
print("List collections: ", client.list_collections())
```
