connection = new Mongo();
database = connection.getDB('evedemo');
database.createUser(
  {
    user: 'user',
    pwd: 'user',
    roles: [
      {
        role: 'readWrite',
        db: 'evedemo'
      }
    ]
  }
);
