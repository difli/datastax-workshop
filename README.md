# DataStax Workshop

## SAI lab
### Using no indexes
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