#!/bin/bash
# restart_service.sh
# Safely restart the checkout-api service, waiting for it to report active.

SERVICE_NAME="checkout-api"
TIMEOUT=30

echo "Checking current status of ${SERVICE_NAME}..."
sudo systemctl status "${SERVICE_NAME}" --no-pager || true

echo "Restarting ${SERVICE_NAME}..."
sudo systemctl restart "${SERVICE_NAME}"

echo "Waiting up to ${TIMEOUT}s for ${SERVICE_NAME} to become active..."
sleep "${TIMEOUT}"

sudo systemctl is-active "${SERVICE_NAME}"
