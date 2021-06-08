# DataStax Workshop
This workshop will show the modern developer APIs for Cassandra using Stargate:
- REST;
- GraphQL;
- Document DB/

Additionally, we'll go into SAI indexes: Indexing in Cassandra on Relational Scale!

## Prerequisites
Make sure to sign up for free on https://astra.datastax.com

## Create a database
1. Browse to https://astra.datastax.com and sign in using your account.
2. Click "Create Database"
3. Enter `datastax` as Database Name and `workshop` as Keyspace Name.
4. Choose any one of the cloud providers, areas and regions.

## Load some sample data
Once the database comes out of `Pending` and is `Active` proceed to loading some sample data:
1. Click the database you just created (`datastax`).
2. Click "Load Data".
3. Click "Movies and TV Shows" and click "Next".
4. Select `show_id` as the Partition Key and click "Next".
5. Select the Target Database (`datastax`) and Target Keyspace (`workshop`) and click "Next".

The data will now be imported and you'll be notified through an e-mail.

## Create an application token
An application token is required for connecting to the APIs.
1. Browse to https://astra.datastax.com/settings/tokens.
2. Select role "Admin User" and click "Generate Token".
3. Click "Download CSV" to have a back-up of the token for later use.

# API Lab
## REST API
1. Browse to https://astra.datastax.com and sign in using your account.
2. Click the "Connect" tab.
3. Click on "REST API".
4. Click on the "Swagger UI" link on the right, this will open a new browser tab.
### Keyspaces
We'll first use the keyspaces endpoint to understand more about the keyspaces in the database.
1. Click "GET /v1/keyspaces".
2. Click "Try it out".
3. Paste the `Application Token` you just generated into `X-Cassandra-Token`.
4. Click "Execute"

You'll see a list of keyspaces available in the database without using any CQL!
### Create a table
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
6. Click "Execute"
```
We just created our first table. You can check it out by clicking the "CQL Console" tab.
### Load some data
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
### Retrieve all data from the table
1. Click "GET /v1/keyspaces/{keyspaceName}/tables/{tableName}rows".
2. Click "Try it out".
3. Paste the `Application Token` you just generated into `X-Cassandra-Token`.
4. Type `workshop` into the `keyspaceName` field.
5. Type `users` into the `tableName` field.
6. Click "Execute"

Now you'll see the row we just added!

## SAI lab
### Without indexes
```sql
select show_id, title from movies_and_tv;

select show_id, title from movies_and_tv where show_id = 81093951;

select show_id, title from movies_and_tv where title = 'Oh! Baby';

select show_id, title from movies_and_tv where title = 'Oh! Baby'
allow filtering;
```
### Using indexes
```sql
create custom index movies_and_tv_title on movies_and_tv(title)
using 'StorageAttachedIndex';

select show_id, title from movies_and_tv where title = 'Oh! Baby';

drop index movies_and_tv_title;
create custom index movies_and_tv_title on movies_and_tv(title)
using 'StorageAttachedIndex'
with options = {'case_sensitive': false, 'normalize': true};

select show_id, title from movies_and_tv where title = 'oh! baby';
```

## Spring backend

### Spring Data AstraDB REST API

```sh
curl -L "<Secure Connect Bundle Zipfile>" > astra-creds.zip

. setup.sh

mvn spring-boot:run
```