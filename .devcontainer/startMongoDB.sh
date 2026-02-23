#!/bin/bash

set -euo pipefail

if ! command -v mongod >/dev/null 2>&1; then
	echo "MongoDB is not installed. Run ./.devcontainer/installMongoDB.sh first." >&2
	exit 1
fi

mkdir -p /data/db
if command -v sudo >/dev/null 2>&1; then
	start_user="$(id -un)"
	sudo chown -R "${start_user}:${start_user}" /data/db
fi

if pgrep -x mongod >/dev/null 2>&1; then
	echo "MongoDB is already running."
else
	mongod --fork --dbpath /data/db --bind_ip 127.0.0.1 --port 27017 --logpath /tmp/mongod.log
	echo "MongoDB has been started successfully!"
fi

mongod --version | head -n 1

if command -v mongosh >/dev/null 2>&1; then
	echo "Current databases:"
	mongosh --quiet --eval "db.getMongo().getDBNames()"
fi