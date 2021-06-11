# ✨ DataStax Stargate + SAI Workshop ✨
This workshop will show the modern developer APIs for Cassandra using Stargate's [REST API](#rest).  
Additionally, we'll go into [SAI indexes](#sai): Indexing in Cassandra at Relational Scale!

## ① Prerequisites
Make sure to sign up for free on https://astra.datastax.com. And why not? You get $25 of credit every month! The $25 credit is good for approximately 30 million reads, 5 million writes, and 40GB of storage per month 🎉.

### ✅ Create a database
1. Browse to https://astra.datastax.com and sign in using your account.
2. Click "Create Database"
3. Enter `datastax` as Database Name and `workshop` as Keyspace Name.
4. Choose any one of the cloud providers, areas and regions.

### ✅ Load some sample data
Once the database comes out of `Pending` and is `Active` proceed to loading some sample data:
1. Click the database you just created (`datastax`).
2. Click "Load Data".
3. Click "Movies and TV Shows" and click "Next".
4. Select `show_id` as the Partition Key and click "Next".
5. Select the Target Database (`datastax`) and Target Keyspace (`workshop`) and click "Next".

The data will now be imported and you'll be notified through an e-mail.

### ✅ Create an application token
An application token is required for connecting to the APIs.
1. Browse to https://astra.datastax.com/settings/tokens.
2. Select role "Admin User" and click "Generate Token".
3. Click "Download CSV" to have a back-up of the token for later use.

## ② <a name="rest"></a> REST API 💡
Here we'll interact with the REST API for Astra (based on [Stargate.io](https://stargate.io)) through the built-in Swagger UI in Astra.
1. Browse to https://astra.datastax.com and sign in using your account.
2. Click the "Connect" tab.
3. Click on "REST API".
4. Click on the "Swagger UI" link on the right, this will open a new browser tab.
### ✅ Keyspaces
We'll first use the keyspaces endpoint to understand more about the keyspaces in the database.
1. Click "GET /v1/keyspaces".
2. Click "Try it out".
3. Paste the `Application Token` you just generated into `X-Cassandra-Token`.
4. Click "Execute"

You'll see a list of keyspaces available in the database without using any CQL!
### ✅ Create a table
Now we'll create a table into our `workshop` keyspace.
1. Click "POST /v1/keyspaces/{keyspaceName}/tables".
2. Click "Try it out".
3. Paste the `Application Token` you just generated into `X-Cassandra-Token`.
4. Type `workshop` into the `keyspaceName` field.
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
6. Click "Execute"

We just created our first table. You can check it out by clicking the "CQL Console" tab.
### ✅ Load some data
Now we'll some data into our newly created table.
1. Click "POST /v1/keyspaces/{keyspaceName}/tables/{tableName}rows".
2. Click "Try it out".
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
7. Click "Execute"
### ✅ Retrieve all data from the table
1. Click "GET /v1/keyspaces/{keyspaceName}/tables/{tableName}rows".
2. Click "Try it out".
3. Paste the `Application Token` you just generated into `X-Cassandra-Token`.
4. Type `workshop` into the `keyspaceName` field.
5. Type `users` into the `tableName` field.
6. Click "Execute"

Now you'll see the row we just added!

## <a name="graphql"></a> ③ GraphQL API 🧩
Now we'll use the upcoming new [API Query Language GraphQL](https://graphql.org/) to interact with Cassandra!

We'll interact with the GraphQL API for Astra (based on [Stargate.io](https://stargate.io)) through the built-in GraphQL UI in Astra.
1. Browse to https://astra.datastax.com and sign in using your account.
2. Click the "Connect" tab.
3. Click on "GraphQL API".
4. Click on the "GraphQL Playground" link on the right. Make sure the first tab "graphql-schema" is selected.
5. Click on "HTTP Headers" on the bottom-left and replace `populate_me` with the `Application Token` you previously generated.
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
Now we'll create two new tables into our `workshop` keyspace. We'll create a `house` table and a table called `residents` to store the persons who live there. In order to do this we'll utilize the `mutations createTable` structure.
1. Paste the following in the payload window on the left:
```graphql
mutation createTables {

  team: createTable(
    keyspaceName: "workshop",
    tableName: "team",
    partitionKeys: [ # The keys required to access your data
      { name: "name", type: {basic: TEXT} }
    ]
    values: [
      { name: "country", type: {basic: TEXT} }
    ]
  )

  race: createTable(
    keyspaceName:"workshop",
    tableName: "race",
    partitionKeys: [
      { name: "name", type: {basic: TEXT} }
    ]
    clusteringKeys: [ # Secondary key used to access values within the partition
      { name: "year", type: {basic: INT}, order: "DESC" },
      { name: "raceteam", type: {basic: TEXT} }
    ]
  )
}
```
2. Click the Play (▶️) button and observe the response.

You just created two tables using GraphQL!
### ✅ Load some data
Before starting the next steps:
* First switch to the "graphql" tab, click on "HTTP Headers" on the bottom-left and replace `populate_me` with your previously generated `Application Token`.
* Then make sure you type `workshop` after the slash `.../graphql/` in the URL.

Now we'll load data into the `race` and `team` tables.

1. Paste the following in the payload window on the left:
```graphql
mutation insertRaceAndTeams {

  update1: insertteam(value: {name: "Max Verstappen", country: "Netherlands"}) {
    value {
      name
    }
  }

  update2: insertrace(value: {name: "GP", year: 2021, raceteam: "Max Verstappen"}) {
    value {
      name
    }
  }

  update3: insertteam(value: {name: "Lewis Hamilton", country: "UK"}) {
    value {
      name
    }
  }

  update4: insertrace(value: {name: "GP", year: 2021, raceteam: "Lewis Hamilton"}) {
    value {
      name
    }
  }
}
```
2. Click the Play (▶️) button and observe the response.

Notice the use of `insertteam`. This notation is used to `insert` data into the `team` table.
### ✅ Query some data
Let's do some fancy querying now.
1. Paste the following in the payload window on the left:
```graphql
query allRaces {

  race {
    values {
      name
      year
      raceteam
    }
  }

}
```
2. Click the Play (▶️) button and observe the response.

Now let's filter this data:
1. Paste the following in the payload window on the left:
```graphql
query someRace {
  race(
    filter: {
      name: { eq: "GP" }
      year: { eq: 2021 }
      raceteam: { eq: "Max Verstappen" }
    }
  ) {
    values {
      name
      year
      raceteam
    }
  }
}
```
2. Click the Play (▶️) button and observe the response.
### ✅ Drop the tables
Now let's drop the tables we just created.
1. Paste the following in the payload window on the left:
```graphql
mutation dropAll {
  dropTeam: dropTable(keyspaceName: "workshop", tableName: "team")
  dropRace: dropTable(keyspaceName: "workshop", tableName: "race")
}
```
2. Click the Play (▶️) button twice while selecting each table and observe the response.

## <a name="document"></a> ④ Document API 🚀

## <a name="sai"></a> ⑤ SAI Indexes 🚀
Here we'll use the sample data you ingested during the prequisites steps.
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

## Spring backend

### Spring Data AstraDB REST API

```sh
curl -L "<Secure Connect Bundle Zipfile>" > astra-creds.zip

. setup.sh

mvn spring-boot:run
```