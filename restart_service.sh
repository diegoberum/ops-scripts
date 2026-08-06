#!/bin/bash
# restart_service.sh
# Safely restart the checkout-api service. Defaults to dry-run for safety;
# edit DRY_RUN below to false to perform a real restart.

SERVICE_NAME="checkout-api"
TIMEOUT=30
DRY_RUN=true

echo "Checking current status of ${SERVICE_NAME}..."
sudo systemctl status "${SERVICE_NAME}" --no-pager || true

if [ "$DRY_RUN" = true ]; then
    echo "[DRY RUN] Would restart ${SERVICE_NAME} now. Set DRY_RUN=false in the script to perform a real restart."
else
    echo "Restarting ${SERVICE_NAME}..."
    sudo systemctl restart "${SERVICE_NAME}"
    echo "Waiting up to ${TIMEOUT}s for ${SERVICE_NAME} to become active..."
    sleep "${TIMEOUT}"
    sudo systemctl is-active "${SERVICE_NAME}"
fi



