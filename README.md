# ✨ DataStax Astra: Stargate + SAI Workshop ✨
This workshop will show the modern developer APIs for Cassandra using Stargate's:
** [REST API 💡](#rest) - Developer friendly endpoints
** [GraphQL API 🧩](#graphql) - Modern GraphQL standard
** [Document API 📚](#document) - Use Cassandra like a Document Database

The Stargate APIs are available by default on [Astra](https://astra.datastax.com) (the Serverless Managed Cloud Cassandra Database by DataStax), [Open Source Cassandra](https://cassandra.apache.org) and [DataStax Enterprise](https://www.datastax.com).

Additionally, we'll go into [SAI indexes 🚀](#sai) - Indexing with Cassandra at Relational Scale! This new type of indexing is available by default on [Astra](https://astra.datastax.com) and [DataStax Enterprise](https://www.datastax.com) > v8.6.3.

## ① Prerequisites
Make sure to sign up for free on https://astra.datastax.com. And why not? You get $25 of credit every month! The $25 credit is good for approximately 30 million reads, 5 million writes, and 40GB of storage per month 🎉.

### ✅ Create a database
1. Browse to https://astra.datastax.com and sign in using your account.
2. Click "Create Database"
3. Enter `datastax` as Database Name and `workshop` as Keyspace Name.
4. Choose any one of the cloud providers, areas and regions.

### ✅ Load some sample data
Once the database comes out of **Pending** and is **Active** proceed to loading some sample data:
1. Click the database you just created (`datastax`).
2. Click **Load Data**.
3. Click `Movies and TV Shows` and click **Next**.
4. Select `show_id` as the **Partition Key** and click **Next**.
5. Select the Target Database (`datastax`) and Target Keyspace (`workshop`) and click **Next**.

The data will now be imported and you'll be notified through an e-mail.

### ✅ Create an application token
An application token is required for connecting to the APIs.
1. Browse to https://astra.datastax.com/settings/tokens.
2. Select role `Admin User` and click **Generate Token**.
3. Click **Download CSV** to have a back-up of the token for later use.

## ② <a name="rest"></a> REST API 💡
Here we'll interact with the REST API for Astra (based on [Stargate.io](https://stargate.io)) through the built-in Swagger UI in Astra.
1. Browse to https://astra.datastax.com and sign in using your account.
2. Click the **Connect** tab.
3. Click on **REST API**.
4. Click on the **Swagger UI** link on the right, this will open a new browser tab.
### ✅ Keyspaces
We'll first use the keyspaces endpoint to understand more about the keyspaces in the database.
1. Click "GET /v1/keyspaces".
2. Click **Try it out**.
3. Paste the `Application Token` you just generated into `X-Cassandra-Token`.
4. Click **Execute**

You'll see a list of keyspaces available in the database without using any CQL!
### ✅ Create a table
Now we'll create a table into our `workshop` keyspace.
1. Click "POST /v1/keyspaces/{keyspaceName}/tables".
2. Click **Try it out**.
3. Paste the `Application Token` you just generated into `X-Cassandra-Token`.
4. Type `workshop` into the **keyspaceName** field.
5. Paste the following payload to create a new table:
```json
{
  "name": "users",
  "primaryKey": {
    "partitionKey": [
      "userid"
    ]
  },
  "columnDefinitions": [
    {
      "name": "userid",
      "typeDefinition": "int"
    },      
    {
      "name": "emailaddress",
      "typeDefinition": "text"
    }
  ],
  "ifNotExists": true
}
```
6. Click **Execute**

We just created our first table! You can check it out by clicking the **CQL Console** tab.
### ✅ Load some data
Now we'll add some data into our newly created table.
1. Click "POST /v1/keyspaces/{keyspaceName}/tables/{tableName}rows".
2. Click **Try it out**.
3. Paste the `Application Token` you just generated into `X-Cassandra-Token`.
4. Type `workshop` into the `keyspaceName` field.
5. Type `users` into the `tableName` field.
6. Paste the following payload to load one row of data:
```json
{
  "columns": [
    {
      "name": "userid",
      "value": "1"
    },
    {
      "name": "emailaddress",
      "value": "michel.deru@company.com"
    }
  ]
}
```
7. Click **Execute**
### ✅ Retrieve all data from the table
1. Click "GET /v1/keyspaces/{keyspaceName}/tables/{tableName}rows".
2. Click **Try it out**.
3. Paste the `Application Token` you just generated into `X-Cassandra-Token`.
4. Type `workshop` into the `keyspaceName` field.
5. Type `users` into the `tableName` field.
6. Click **Execute**

Now you'll see the row we just added!

## <a name="graphql"></a> ③ GraphQL API 🧩
Now we'll use the upcoming new [API Query Language GraphQL](https://graphql.org/) to interact with Cassandra!

We'll interact with the GraphQL API for Astra (based on [Stargate.io](https://stargate.io)) through the built-in GraphQL UI in Astra.
1. Browse to https://astra.datastax.com and sign in using your account.
2. Click the **Connect** tab.
3. Click on **GraphQL API**.
4. Click on the **GraphQL Playground** link on the right. Make sure the first tab **graphql-schema** is selected.
5. Click on **HTTP Headers** on the bottom-left and replace `populate_me` with the `Application Token` you previously generated.
### ✅ Keyspaces
We'll first query for keyspaces in the database.
1. Paste the following in the payload window on the left:
```graphql
{
  keyspaces {
    name
  }
}
```
2. Click the Play (▶️) button.

You just ran your first GraphQL query and retrieved all keyspaces without using any CQL!
### ✅ Create a table
Now we'll create two new tables into our `workshop` keyspace. We'll create a `books` table and a table called `authors`. In order to do this we'll utilize the `mutations createTable` structure.
1. Paste the following in the payload window on the left:
```graphql
mutation createTables {
  
  table1: createTable(
    keyspaceName: "workshop"
    tableName: "books"
    partitionKeys: [
      # The keys required to access your data
      { name: "name", type: { basic: TEXT } }
    ]
    clusteringKeys: [
      # Secondary key used to access values within the partition
      { name: "author", type: { basic: TEXT } }
    ]
  )

  table2: createTable(
    keyspaceName: "workshop"
    tableName: "authors"
    partitionKeys: [
      # The keys required to access your data
      { name: "name", type: { basic: TEXT } }
    ]
    values: [
      # Additional fields
      { name: "country", type: { basic: INT } }
    ]
  )

}
```
2. Click the Play (▶️) button and observe the response.

You just created two tables using GraphQL!
### ✅ Load some data
Before starting the next steps:
** First switch to the **graphql** tab, click on **HTTP Headers** on the bottom-left and replace `populate_me` with your previously generated `Application Token`.
** Then make sure you type `workshop` after the slash `.../graphql/` in the URL (replacing `system` or `yourKeyspace`).

Now we'll load data into the `books` and `authors` tables.

1. Paste the following in the payload window on the left:
```graphql
mutation insertData {
  
  update1: insertbooks(
    value: {
      name: "Harry Potter and the Sorcerer's Stone"
      author: "J.K. Rowling"
    }
  ) {
    value {
      name
    }
  }

  update2: insertbooks(
    value: {
      name: "Harry Potter and the Chamber of Secrets"
      author: "J.K. Rowling"
    }
  ) {
    value {
      name
    }
  }

  update3: insertauthors(value: { name: "J.K. Rowling", country: "UK" }) {
    value {
      name
    }
  }

}
```
2. Click the Play (▶️) button and observe the response.

Notice the use of `insertbooks`. This notation is used to `insert` data into the `books` table.
### ✅ Query some data
Let's do some fancy querying now.
1. Paste the following in the payload window on the left:
```graphql
query allBooks {

  books {
    values {
      name
      author
    }
  }

}
```
2. Click the Play (▶️) button and observe the response.

Now let's filter this data:
1. Paste the following in the payload window on the left:
```graphql
query someBook {
  
  books(
    filter: { 
      name: { 
        eq: "Harry Potter and the Sorcerer's Stone" } 
    }
  ) {
    values {
      name
      author
    }
  }
  
}
```
2. Click the Play (▶️) button and observe the response.
### ✅ Drop the tables
Now let's drop the tables we just created.

Before we do that, first switch back the **graphql-schema** tab.

1. Paste the following in the payload window on the left:
```graphql
mutation dropAll {

  dropTable1: dropTable(keyspaceName: "workshop", tableName: "books")
  dropTable2: dropTable(keyspaceName: "workshop", tableName: "authors")

}
```
2. Click the Play (▶️) button twice while selecting each table and observe the response.

## <a name="document"></a> ④ Document API 📚
Now let's make Cassandra the best of both worlds with not just wide-row modelling but also document modelling!

Here we'll interact with the Document API for Astra (based on [Stargate.io](https://stargate.io)) through the built-in Swagger UI in Astra.
1. Browse to https://astra.datastax.com and sign in using your account.
2. Click the **Connect** tab.
3. Click on **Document API**.
4. Click on the **Swagger UI** link on the right, this will open a new browser tab.
### ✅ Namespaces
Namespaces in the document world are the equivalent of Keyspaces in the wide-row world.

We'll first use the namespaces endpoint to understand more about the namespaces in the database.
1. Click "GET /v2/schemas/namespaces".
2. Click **Try it out**.
3. Paste the `Application Token` you just generated into `X-Cassandra-Token`.
4. Click **Execute**

You'll see all Keyspaces in the database, however in the Document Realm they are calles Namespaces.
### ✅ Collections
Let's create a collection where our documents will reside.
1. Click "POST /v2/namespaces/{namespace-id}/collections".
2. Click **Try it out**.
3. Paste the `Application Token` you just generated into `X-Cassandra-Token`.
4. Type `workshop` in the `namespace-id` field.
5. Paste the following payload to create a new table:
```json
{
    "name": "cars"
}
```
6. Click **Execute**

You just created a new collection. Actually a collection is the equivalent of a table in the wide-row world.
### ✅ Store a document
Let's create a collection where our documents will reside.
1. Click "POST /v2/namespaces/{namespace-id}/collections/{collection-id}".
2. Click **Try it out**.
3. Paste the `Application Token` you just generated into `X-Cassandra-Token`.
4. Type `workshop` in the `namespace-id` field.
5. Type `cars` in the `collection-id` field.
6. Paste the following payload to create a document:
```json
{
    "brand": "BMW",
    "model": "535d xDrive",
    "year": 2013,
    "engine": {
        "type": "diesel",
        "cylinders": 6,
        "turbo": 2
    }
}
```
6. Click **Execute**

You just created a new document! Note that you didn't have to define a model at all. Also note that you can use hierarchy in the document.

Let's add another document, just replace the payload with the following and press **Execute**:
```json
{
    "brand": "BMW",
    "model": "X5 xDrive40e",
    "year": 2015,
    "engine": [
        {
            "type": "petrol",
            "cylinders": 4,
            "turbo": 1,
            "compressor": 1
        },
        {
            "type": "electric"
        }
    ]
}
```
And again, we just schemalessly ingested a new document with different structure. Note that the response shows the document ID under which the document is saved.
### ✅ Query a collection
Now let's query the data without the need for creating indexes!
1. Click "GET /v2​/namespaces​/{namespace-id}​/collections​/{collection-id}".
2. Click **Try it out**.
3. Paste the `Application Token` you just generated into `X-Cassandra-Token`.
4. Type `workshop` in the `namespace-id` field.
5. Type `cars` in the `collection-id` field.
6. Type `{ "brand": {"$eq": "BMW"}}` in the `where` field.
7. Type `20` in the `page-size` field.
8. Click **Execute**

You just retrieved all data for BMW cars. Notice the different document models you get back!

Now let's filter a bit better:
1. Change the `where` field to show `{ "brand": {"$eq": "BMW"}, "year": {"$gte": 2015}}`
2. Click **Execute**

You just filtered out to just one car!

## <a name="sai"></a> ⑤ SAI Indexes 🚀
Here we'll use the sample data you ingested during the prequisites steps.

In this lab you'll see how easy it is to leverage scalable indexes to allow "relational-type" indexing and searching in Cassandra without using a primary key. This allows you to prevent data duplication and denormalization you'd normally have to use to create new query entrances into your data!

Here we'll use the **CQL Console** that is available in Astra:
1. Browse to https://astra.datastax.com and sign in using your account.
2. Click the **CQL Console** tab.

### ✅ Without indexes
Without the SAI index, we can only access the data through the primary key:
```sql
select show_id, title from movies_and_tv;

select show_id, title from movies_and_tv where show_id = 81093951;
```
Now if we want to search on the `title`, the following query is going to fail:
```sql
select show_id, title from movies_and_tv where title = 'Oh! Baby';
```
The only way to search on the `title` is to use `allow filtering`. At scale however, that is not an option!
```sql
select show_id, title from movies_and_tv where title = 'Oh! Baby' allow filtering;
```
### ✅ Using SAI
Let's first create the index and allow Cassandra some time to build up the index:
```sql
create custom index movies_and_tv_title on movies_and_tv(title) using 'StorageAttachedIndex';
```
And let the magic begin! Now you can filter on `title`:
```sql
select show_id, title from movies_and_tv where title = 'Oh! Baby';
```
The nice thing is you can also allow for case-insensitive searching!
```sql
drop index movies_and_tv_title;
create custom index movies_and_tv_title on movies_and_tv(title) using 'StorageAttachedIndex' with options = {'case_sensitive': false, 'normalize': true};

select show_id, title from movies_and_tv where title = 'oh! baby';
```

Happy **cass-ing**!