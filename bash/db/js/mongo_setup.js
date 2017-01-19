use admin

db.createUser(
  {
    user: "hermes-db-mongo-admin",
    pwd: "N@ture93!",
    roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
  }
)

use metrics

db.createUser(
  {
    user: "hermes-db-mongo-user",
    pwd: "N@ture93!",
    roles: [ { role: "readWrite", db: "metrics" } ]
  }
)

db.createUser(
  {
    user: "external-db-mongo-exploitation",
    pwd: "N@ture93!",
    roles: [ { role: "read", db: "metrics" } ]
  }
)
