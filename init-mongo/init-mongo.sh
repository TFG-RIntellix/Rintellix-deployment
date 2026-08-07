#!/bin/bash
set -e

echo "Starting MongoDB initialization..."

# Create application user
mongosh --username "$MONGO_INITDB_ROOT_USERNAME" \
        --password "$MONGO_INITDB_ROOT_PASSWORD" \
        --authenticationDatabase admin \
        --host mongodb \
        --eval "
db = db.getSiblingDB('$MONGO_DB_NAME');
if (db.getUser('$MONGO_APP_USER') == null) {
  db.createUser({
    user: '$MONGO_APP_USER',
    pwd: '$MONGO_APP_PASSWORD',
    roles: [{ role: 'readWrite', db: '$MONGO_DB_NAME' }]
  });
} else {
  db.updateUser('$MONGO_APP_USER', {
    pwd: '$MONGO_APP_PASSWORD',
    roles: [{ role: 'readWrite', db: '$MONGO_DB_NAME' }]
  });
}
"

echo "User created. Starting mongorestore..."

# Restore data from the dump directory (mounted at /dump/RIntellix)
# Use the newly created app credentials or root. Here we use root to ensure permissions.
mongorestore --username "$MONGO_INITDB_ROOT_USERNAME" \
             --password "$MONGO_INITDB_ROOT_PASSWORD" \
             --authenticationDatabase admin \
             --host mongodb \
             --db "$MONGO_DB_NAME" \
             --nsExclude="${MONGO_DB_NAME}.reports" \
             --drop \
             /dump/RIntellix

echo "MongoDB initialization completed successfully!"
