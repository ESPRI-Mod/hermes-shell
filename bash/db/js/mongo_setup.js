// Connect to db server.
var server = new Mongo();
var db = server.getDB("metrics1");

print(db);

// // Create general users.
// var user = db.getUser("prodiguer-db-mongo-user");

// print(user);

// if (db.getUser("prodiguer-db-mongo-user")) {
//     db.createUser({
//         user: "prodiguer-db-mongo-user",
//         pwd: "N@ture93!",
//         roles: [
//             { role: "readWrite", db: "metrics" }
//         ]
//     });
// }
