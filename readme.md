### mongo

see instructions: https://hub.docker.com/_/mongo

docker ps

```
5b6ccffb1c34   mongo           "docker-entrypoint.s…"   30 minutes ago   Up 29 minutes   0.0.0.0:27017->27017/tcp   prje_mongo_1
6a3545b9af46   mongo-express   "tini -- /docker-ent…"   30 minutes ago   Up 29 minutes   0.0.0.0:9081->8081/tcp     prje_mongo-express_1
```

```
docker exec -it 5b6ccffb1c34 bash
```

inside the shell
```
mongo -u root -p example
```


create user
see instructions: https://www.mongodb.com/docs/manual/tutorial/create-users/

```
use test
db.createUser({user: 'user', pwd: 'pass', roles: [{role: "dbOwner", db: "test"}]})
```

log into mongo using the created user

```
mongo -u user -p pass --authenticationDatabase test
```


### account

/account/signup

```
curl --location --request POST 'localhost:8000/account/signup' \
--form 'username="user"' \
--form 'email="user@gmail.com"' \
--form 'password="pass"'
```


### start up service

```
docker-compose up -d
docker compose up app --build # if Gemfile is changed
```


### develop locally

```
make dev
```


### test

```
make test
```
