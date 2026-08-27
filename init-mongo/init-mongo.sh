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

echo "Cleaning up obsolete collections..."
mongosh --username "$MONGO_INITDB_ROOT_USERNAME" \
        --password "$MONGO_INITDB_ROOT_PASSWORD" \
        --authenticationDatabase admin \
        --host mongodb \
        --eval "
db = db.getSiblingDB('$MONGO_DB_NAME');
db.simulations.drop();
db.scorings.drop();
db.reports.drop();
"

echo "Importing fresh JSON data..."
mongoimport --username "$MONGO_INITDB_ROOT_USERNAME" \
            --password "$MONGO_INITDB_ROOT_PASSWORD" \
            --authenticationDatabase admin \
            --host mongodb \
            --db "$MONGO_DB_NAME" \
            --collection parties \
            --drop \
            --jsonArray \
            --file /dump/parties.json

mongoimport --username "$MONGO_INITDB_ROOT_USERNAME" \
            --password "$MONGO_INITDB_ROOT_PASSWORD" \
            --authenticationDatabase admin \
            --host mongodb \
            --db "$MONGO_DB_NAME" \
            --collection requests \
            --drop \
            --jsonArray \
            --file /dump/requests.json

echo "MongoDB initialization completed successfully!"
