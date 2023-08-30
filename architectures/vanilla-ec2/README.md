## How to use?
1. Visit instance through public ip.
```
ssh -i ssh-chroma.pem ec2-user@{public-ip}
```
2. Visit chroma heartbeat.
```
curl {public-ip}:8000/api/v1/heartbeat
```
