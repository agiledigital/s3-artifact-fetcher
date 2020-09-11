#!/bin/ash

# Use the Unofficial Bash Strict Mode (Unless You Looove Debugging)
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

if [ -z "${RUNNER_USER:-}" ] || [ -z "${ARTIFACT_DIR:-}" ] || [ -z "${SOURCE_URL:-}" ]; then
    echo "You must specify RUNNER_USER, ARTIFACT_DIR and SOURCE_URL."
    exit 1
fi

# Ensure that assigned uid has entry in /etc/passwd.
if touch /etc/passwd && [ "$(id -u)" -ge 10000 ]; then
    echo "Patching /etc/passwd to make ${RUNNER_USER} -> builder and $(id -u) -> ${RUNNER_USER}"
    sed -e "s/${RUNNER_USER}/builder/g" > /tmp/passwd < /etc/passwd
    echo "${RUNNER_USER}:x:$(id -u):$(id -g):,,,:/home/${RUNNER_USER}:/bin/bash" >> /tmp/passwd
    cat /tmp/passwd > /etc/passwd
    rm /tmp/passwd
fi

echo "Retrieving artifacts from s3..."
aws s3 sync --delete "${SOURCE_URL}" "${ARTIFACT_DIR}"

cd "${ARTIFACT_DIR}"
echo "Verifying artifacts..."
find . -name \*.tar.gz -exec tar -tvf {} \;
echo "Unzipping artifacts..."
find . -name \*.tar.gz -exec gunzip {} \;
echo "Extracting artifacts..."
find . -name \*.tar -exec tar -xf {} \; -exec rm {} \;
