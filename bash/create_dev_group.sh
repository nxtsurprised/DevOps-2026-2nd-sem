#!/usr/bin/env bash

set -u
set -o pipefail

LOG_FILE="./create_dev_group.log"
DEV_GROUP="dev"
WORKDIR_BASE=""

usage() {
  cat <<USAGE
Usage: sudo $0 [-d PATH]

Options:
  -d PATH   Base directory where <user_name>_workdir directories will be created
  -h        Show help
USAGE
}

log() {
  local message="$1"
  echo "$(date '+%Y-%m-%d %H:%M:%S') | ${message}" | tee -a "$LOG_FILE"
}

fail() {
  log "ERROR: $1"
  exit 1
}

check_root() {
  if [[ "${EUID}" -ne 0 ]]; then
    fail "Script must be run as root. Use sudo."
  fi
}

parse_args() {
  while getopts ":d:h" opt; do
    case "$opt" in
      d)
        WORKDIR_BASE="$OPTARG"
        ;;
      h)
        usage
        exit 0
        ;;
      :)
        fail "Option -$OPTARG requires an argument."
        ;;
      \?)
        fail "Unknown option: -$OPTARG"
        ;;
    esac
  done
}

request_workdir_base_if_empty() {
  if [[ -z "$WORKDIR_BASE" ]]; then
    read -r -p "Enter base directory path: " WORKDIR_BASE
  fi

  if [[ -z "$WORKDIR_BASE" ]]; then
    fail "Base directory path cannot be empty."
  fi
}

prepare_base_directory() {
  mkdir -p "$WORKDIR_BASE" || fail "Cannot create base directory: $WORKDIR_BASE"
  log "Base directory is ready: $WORKDIR_BASE"
}

create_dev_group() {
  if getent group "$DEV_GROUP" > /dev/null; then
    log "Group '$DEV_GROUP' already exists."
  else
    groupadd "$DEV_GROUP" || fail "Cannot create group '$DEV_GROUP'."
    log "Group '$DEV_GROUP' created."
  fi
}

configure_passwordless_sudo() {
  local sudoers_file="/etc/sudoers.d/${DEV_GROUP}"

  echo "%${DEV_GROUP} ALL=(ALL) NOPASSWD:ALL" > "$sudoers_file" || fail "Cannot write sudoers file."
  chmod 0440 "$sudoers_file" || fail "Cannot set permissions for sudoers file."

  if visudo -cf "$sudoers_file" > /dev/null; then
    log "Passwordless sudo configured for group '$DEV_GROUP'."
  else
    rm -f "$sudoers_file"
    fail "Invalid sudoers configuration. File removed: $sudoers_file"
  fi
}

get_non_system_users() {
  local uid_min
  local uid_max

  uid_min=$(awk '/^UID_MIN/ {print $2}' /etc/login.defs | tail -n 1)
  uid_max=$(awk '/^UID_MAX/ {print $2}' /etc/login.defs | tail -n 1)

  uid_min=${uid_min:-1000}
  uid_max=${uid_max:-60000}

  awk -F: -v min="$uid_min" -v max="$uid_max" '($3 >= min && $3 <= max && $1 != "nobody") {print $1}' /etc/passwd
}

add_user_to_dev_group() {
  local username="$1"

  usermod -aG "$DEV_GROUP" "$username" || fail "Cannot add user '$username' to group '$DEV_GROUP'."
  log "User '$username' added to group '$DEV_GROUP'."
}

create_user_workdir() {
  local username="$1"
  local user_group
  local target_dir

  user_group=$(id -gn "$username") || fail "Cannot get primary group for user '$username'."
  target_dir="${WORKDIR_BASE}/${username}_workdir"

  mkdir -p "$target_dir" || fail "Cannot create directory: $target_dir"
  chown "${username}:${user_group}" "$target_dir" || fail "Cannot set owner for: $target_dir"
  chmod 0660 "$target_dir" || fail "Cannot set mode 660 for: $target_dir"

  if command -v setfacl > /dev/null 2>&1; then
    setfacl -m "g:${DEV_GROUP}:r--" "$target_dir" || fail "Cannot set ACL for group '$DEV_GROUP' on '$target_dir'."
    log "Directory created: $target_dir | owner=${username} | group=${user_group} | mode=660 | ACL group ${DEV_GROUP}=read"
  else
    log "WARNING: setfacl not found. Directory created without ACL for group '$DEV_GROUP': $target_dir"
  fi
}

main() {
  : > "$LOG_FILE" || exit 1

  check_root
  parse_args "$@"
  request_workdir_base_if_empty

  log "Script started."
  log "Log file: $LOG_FILE"

  prepare_base_directory
  create_dev_group
  configure_passwordless_sudo

  mapfile -t users < <(get_non_system_users)

  if [[ "${#users[@]}" -eq 0 ]]; then
    log "No non-system users found."
    exit 0
  fi

  log "Non-system users found: ${users[*]}"

  for username in "${users[@]}"; do
    add_user_to_dev_group "$username"
    create_user_workdir "$username"
  done

  log "Script finished successfully."
}

main "$@"
