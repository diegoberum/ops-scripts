# Runbook: Restarting checkout-api

## When to use

`checkout-api` needs to be restarted.

## Steps

1. Open `restart_service.sh`.
2. Confirm `DRY_RUN` near the top of the file. If it reads `DRY_RUN=true`, change it to `DRY_RUN=false`.
3. Save the file.
4. Run the script: `./restart_service.sh`
5. Read the printed output of `systemctl status checkout-api` (step 1 of the script's output) to confirm the pre-restart state.
6. Confirm the script prints `Restarting checkout-api...` — this confirms it is running in live mode, not dry-run.
7. Wait for the script to finish. It will sleep for up to 30 seconds (`TIMEOUT`) after issuing the restart.
8. Read the final line of output: the result of `systemctl is-active checkout-api`.
9. If the output is `active`: restart succeeded. Done.
10. If the output is anything other than `active` (e.g. `failed`, `activating`, `inactive`): restart did not complete successfully within 30 seconds. Proceed to Troubleshooting.

## Troubleshooting

1. Re-run `sudo systemctl status checkout-api --no-pager` directly to get full status and recent logs.
2. Re-run `sudo systemctl is-active checkout-api` directly — the service may have become active after the script's 30-second wait ended.
3. If still not active, check service logs directly (not covered by this script).
4. If `sudo systemctl restart checkout-api` returned a permission error, confirm the user running the script has `sudo` rights.
5. If all of the above fail and status/restart output indicates the unit is not found or not loaded (e.g. Unit checkout-api.service could not be found), the service may not be installed or registered on this host under that name. Verify with systemctl list-units --all | grep checkout-api before continuing.

## After the incident

1. Reopen `restart_service.sh`.
2. Set `DRY_RUN` back to `true`.
3. Save the file.
