import chromadb

hostname = "dlifw0fefe.execute-api.eu-west-2.amazonaws.com/dev"
apikey = "YmOjJyAdHf67hOKNM00ulaWWK4Aa5xrS5kBWtE6I"

client = chromadb.HttpClient(
    host=hostname,
    ssl=True,
    port="",
    headers={
        "X-Api-Key": apikey
    }
)
print("Heartbeat: ", client.heartbeat())
print("List collections: ", client.list_collections())

collection = client.get_or_create_collection("testname")
collection.add(
    embeddings=[1.5, 2.9, 3.4],
    metadatas={"uri": "img9.png", "style": "style1"},
    documents="doc1000101",
    ids="uri9",
)
print(collection.get())
print(collection.query(
    query_embeddings=[[1.1, 2.3, 3.2], [5.1, 4.3, 2.2]],
    n_results=2,
    where={"style": "style2"}
))
client.delete_collection("testname")
