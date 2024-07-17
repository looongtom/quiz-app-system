db.createUser(
    {
        user: "tom",
        pwd: "123456",
        roles: [ "readWrite", "dbAdmin" ]
    }
);
db.createCollection("test");
