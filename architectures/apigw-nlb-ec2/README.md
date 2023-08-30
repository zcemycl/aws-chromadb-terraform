## How to use?
1. Python sdk from chroma-core
```
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
