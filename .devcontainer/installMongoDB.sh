#!/bin/bash

set -euo pipefail

if command -v mongod >/dev/null 2>&1; then
	echo "MongoDB already installed."
	exit 0
fi

source /etc/os-release

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://pgp.mongodb.com/server-7.0.asc | sudo gpg --dearmor -o /etc/apt/keyrings/mongodb-server-7.0.gpg

if [[ "${ID}" == "ubuntu" ]]; then
	codename="${VERSION_CODENAME}"
	repo_line="deb [ arch=amd64,arm64 signed-by=/etc/apt/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu ${codename}/mongodb-org/7.0 multiverse"
elif [[ "${ID}" == "debian" ]]; then
	codename="${VERSION_CODENAME}"
	if [[ "${codename}" == "trixie" ]]; then
		codename="bookworm"
	fi
	repo_line="deb [ arch=amd64,arm64 signed-by=/etc/apt/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/debian ${codename}/mongodb-org/7.0 main"
else
	echo "Unsupported distro for automated MongoDB install: ${ID}" >&2
	exit 1
fi

echo "${repo_line}" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list >/dev/null

if ! sudo apt-get update; then
	echo "Error: secure apt update failed for MongoDB repo; aborting installation to avoid bypassing APT security checks." >&2
	echo "Please verify your network and APT configuration, or consider using an official MongoDB Docker image instead of installing MongoDB in this dev container." >&2
	exit 1
fi

sudo apt-get install -y mongodb-org mongodb-mongosh
sudo mkdir -p /data/db
install_user="$(id -un)"
sudo chown -R "${install_user}:${install_user}" /data/db
