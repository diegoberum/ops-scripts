# restart_service.sh

## Purpose

Safely restart the `checkout-api` service. The script defaults to a dry run: it reports what it would do without actually restarting anything, so it can be executed without side effects unless explicitly configured otherwise.

## Usage

Run the script directly:

```
./restart_service.sh
```

By default (`DRY_RUN=true`), it will:
1. Print the current status of `checkout-api` via `systemctl status`.
2. Print a `[DRY RUN]` message indicating what it would do, without restarting the service.

To perform an actual restart, edit the script and change `DRY_RUN=true` to `DRY_RUN=false` near the top of the file, then run it again. With `DRY_RUN=false`, it will:
1. Print the current status of `checkout-api`.
2. Restart `checkout-api` via `systemctl restart`.
3. Wait up to `TIMEOUT` seconds (30 by default) via `sleep`.
4. Print the result of `systemctl is-active checkout-api`.

There is no command-line flag to toggle dry-run behavior — it is controlled only by editing the `DRY_RUN` variable in the script.

## Prerequisites

- `sudo` privileges: every `systemctl` call in the script is prefixed with `sudo`.
- `systemctl` available on the system (the script calls `systemctl status`, `systemctl restart`, and `systemctl is-active`).
- A service named `checkout-api` registered with systemd, since `SERVICE_NAME="checkout-api"` is hardcoded.

## Troubleshooting

- **Status check fails or the service doesn't exist yet:** The initial `systemctl status` call is followed by `|| true`, so a non-zero exit from that command will not stop the script from continuing.
- **Script appears to do nothing:** Check whether `DRY_RUN` is set to `true` at the top of the script — this is the default, and in this mode the service is never actually restarted.
- **Restart doesn't take effect / service not active after running:** The script waits a fixed `TIMEOUT` of 30 seconds after issuing the restart, then prints the output of `systemctl is-active checkout-api`. If the service takes longer than 30 seconds to become active, the script will not wait further or retry — check the printed `is-active` output and the service's own logs directly.
- **Permission errors:** All `systemctl` calls use `sudo`; if these fail, confirm the user running the script has the necessary `sudo` permissions.
