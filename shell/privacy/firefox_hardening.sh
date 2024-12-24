#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]; then
  script_path=$([[ "$0" = /* ]] && echo "$0" || echo "$PWD/${0#./}")
  sudo "$script_path" || (
    echo 'Administrator privileges are required.'
    exit 1
  )
  exit 0
fi
export HOME="/home/${SUDO_USER:-${USER}}" # Keep `~` and `$HOME` for user not `/root`.


# ----------------------------------------------------------
# ---------Disable Firefox Pioneer study monitoring---------
# ----------------------------------------------------------
echo '--- Disable Firefox Pioneer study monitoring'
pref_name='toolkit.telemetry.pioneer-new-studies-available'
pref_value='false'
echo "Setting preference \"$pref_name\" to \"$pref_value\"."
declare -a profile_paths=(
  ~/.mozilla/firefox/*/
  ~/.var/app/org.mozilla.firefox/.mozilla/firefox/*/
  ~/snap/firefox/common/.mozilla/firefox/*/
)
declare -i total_profiles_found=0
for profile_dir in "${profile_paths[@]}"; do
  if [ ! -d "$profile_dir" ]; then
    continue
  fi
  if [[ ! "$(basename "$profile_dir")" =~ ^[a-z0-9]{8}\..+ ]]; then
    continue # Not a profile folder
  fi
  ((total_profiles_found++))
  user_js_file="${profile_dir}user.js"
  echo "$user_js_file:"
  if [ ! -f "$user_js_file" ]; then
    touch "$user_js_file"
    echo $'\t''Created new user.js file'
  fi
  pref_start="user_pref(\"$pref_name\","
  pref_line="user_pref(\"$pref_name\", $pref_value);"
  if ! grep --quiet "^$pref_start" "${user_js_file}"; then
    echo -n $'\n'"$pref_line" >> "$user_js_file"
    echo $'\t'"Successfully added a new preference in $user_js_file."
  elif grep --quiet "^$pref_line$" "$user_js_file"; then
    echo $'\t'"Skipping, preference is already set as expected in $user_js_file."
  else
    sed --in-place "/^$pref_start/c\\$pref_line" "$user_js_file"
    echo $'\t'"Successfully replaced the existing incorrect preference in $user_js_file."
  fi
done
if [ "$total_profiles_found" -eq 0 ]; then
  echo 'No profile folders are found, no changes are made.'
else
  echo "Successfully verified preferences in $total_profiles_found profiles."
fi
# ----------------------------------------------------------


# ----------------------------------------------------------
# -------------Clear Firefox pioneer program ID-------------
# ----------------------------------------------------------
echo '--- Clear Firefox pioneer program ID'
pref_name='toolkit.telemetry.pioneerId'
pref_value='""'
echo "Setting preference \"$pref_name\" to \"$pref_value\"."
declare -a profile_paths=(
  ~/.mozilla/firefox/*/
  ~/.var/app/org.mozilla.firefox/.mozilla/firefox/*/
  ~/snap/firefox/common/.mozilla/firefox/*/
)
declare -i total_profiles_found=0
for profile_dir in "${profile_paths[@]}"; do
  if [ ! -d "$profile_dir" ]; then
    continue
  fi
  if [[ ! "$(basename "$profile_dir")" =~ ^[a-z0-9]{8}\..+ ]]; then
    continue # Not a profile folder
  fi
  ((total_profiles_found++))
  user_js_file="${profile_dir}user.js"
  echo "$user_js_file:"
  if [ ! -f "$user_js_file" ]; then
    touch "$user_js_file"
    echo $'\t''Created new user.js file'
  fi
  pref_start="user_pref(\"$pref_name\","
  pref_line="user_pref(\"$pref_name\", $pref_value);"
  if ! grep --quiet "^$pref_start" "${user_js_file}"; then
    echo -n $'\n'"$pref_line" >> "$user_js_file"
    echo $'\t'"Successfully added a new preference in $user_js_file."
  elif grep --quiet "^$pref_line$" "$user_js_file"; then
    echo $'\t'"Skipping, preference is already set as expected in $user_js_file."
  else
    sed --in-place "/^$pref_start/c\\$pref_line" "$user_js_file"
    echo $'\t'"Successfully replaced the existing incorrect preference in $user_js_file."
  fi
done
if [ "$total_profiles_found" -eq 0 ]; then
  echo 'No profile folders are found, no changes are made.'
else
  echo "Successfully verified preferences in $total_profiles_found profiles."
fi
# ----------------------------------------------------------


# ----------------------------------------------------------
# -------Minimize Firefox telemetry logging verbosity-------
# ----------------------------------------------------------
echo '--- Minimize Firefox telemetry logging verbosity'
pref_name='toolkit.telemetry.log.level'
pref_value='"Fatal"'
echo "Setting preference \"$pref_name\" to \"$pref_value\"."
declare -a profile_paths=(
  ~/.mozilla/firefox/*/
  ~/.var/app/org.mozilla.firefox/.mozilla/firefox/*/
  ~/snap/firefox/common/.mozilla/firefox/*/
)
declare -i total_profiles_found=0
for profile_dir in "${profile_paths[@]}"; do
  if [ ! -d "$profile_dir" ]; then
    continue
  fi
  if [[ ! "$(basename "$profile_dir")" =~ ^[a-z0-9]{8}\..+ ]]; then
    continue # Not a profile folder
  fi
  ((total_profiles_found++))
  user_js_file="${profile_dir}user.js"
  echo "$user_js_file:"
  if [ ! -f "$user_js_file" ]; then
    touch "$user_js_file"
    echo $'\t''Created new user.js file'
  fi
  pref_start="user_pref(\"$pref_name\","
  pref_line="user_pref(\"$pref_name\", $pref_value);"
  if ! grep --quiet "^$pref_start" "${user_js_file}"; then
    echo -n $'\n'"$pref_line" >> "$user_js_file"
    echo $'\t'"Successfully added a new preference in $user_js_file."
  elif grep --quiet "^$pref_line$" "$user_js_file"; then
    echo $'\t'"Skipping, preference is already set as expected in $user_js_file."
  else
    sed --in-place "/^$pref_start/c\\$pref_line" "$user_js_file"
    echo $'\t'"Successfully replaced the existing incorrect preference in $user_js_file."
  fi
done
if [ "$total_profiles_found" -eq 0 ]; then
  echo 'No profile folders are found, no changes are made.'
else
  echo "Successfully verified preferences in $total_profiles_found profiles."
fi
# ----------------------------------------------------------


# ----------------------------------------------------------
# -----------Disable Firefox telemetry log output-----------
# ----------------------------------------------------------
echo '--- Disable Firefox telemetry log output'
pref_name='toolkit.telemetry.log.dump'
pref_value='"Fatal"'
echo "Setting preference \"$pref_name\" to \"$pref_value\"."
declare -a profile_paths=(
  ~/.mozilla/firefox/*/
  ~/.var/app/org.mozilla.firefox/.mozilla/firefox/*/
  ~/snap/firefox/common/.mozilla/firefox/*/
)
declare -i total_profiles_found=0
for profile_dir in "${profile_paths[@]}"; do
  if [ ! -d "$profile_dir" ]; then
    continue
  fi
  if [[ ! "$(basename "$profile_dir")" =~ ^[a-z0-9]{8}\..+ ]]; then
    continue # Not a profile folder
  fi
  ((total_profiles_found++))
  user_js_file="${profile_dir}user.js"
  echo "$user_js_file:"
  if [ ! -f "$user_js_file" ]; then
    touch "$user_js_file"
    echo $'\t''Created new user.js file'
  fi
  pref_start="user_pref(\"$pref_name\","
  pref_line="user_pref(\"$pref_name\", $pref_value);"
  if ! grep --quiet "^$pref_start" "${user_js_file}"; then
    echo -n $'\n'"$pref_line" >> "$user_js_file"
    echo $'\t'"Successfully added a new preference in $user_js_file."
  elif grep --quiet "^$pref_line$" "$user_js_file"; then
    echo $'\t'"Skipping, preference is already set as expected in $user_js_file."
  else
    sed --in-place "/^$pref_start/c\\$pref_line" "$user_js_file"
    echo $'\t'"Successfully replaced the existing incorrect preference in $user_js_file."
  fi
done
if [ "$total_profiles_found" -eq 0 ]; then
  echo 'No profile folders are found, no changes are made.'
else
  echo "Successfully verified preferences in $total_profiles_found profiles."
fi
# ----------------------------------------------------------


# ----------------------------------------------------------
# --------Disable pings to Firefox telemetry server---------
# ----------------------------------------------------------
echo '--- Disable pings to Firefox telemetry server'
pref_name='toolkit.telemetry.server'
pref_value='""'
echo "Setting preference \"$pref_name\" to \"$pref_value\"."
declare -a profile_paths=(
  ~/.mozilla/firefox/*/
  ~/.var/app/org.mozilla.firefox/.mozilla/firefox/*/
  ~/snap/firefox/common/.mozilla/firefox/*/
)
declare -i total_profiles_found=0
for profile_dir in "${profile_paths[@]}"; do
  if [ ! -d "$profile_dir" ]; then
    continue
  fi
  if [[ ! "$(basename "$profile_dir")" =~ ^[a-z0-9]{8}\..+ ]]; then
    continue # Not a profile folder
  fi
  ((total_profiles_found++))
  user_js_file="${profile_dir}user.js"
  echo "$user_js_file:"
  if [ ! -f "$user_js_file" ]; then
    touch "$user_js_file"
    echo $'\t''Created new user.js file'
  fi
  pref_start="user_pref(\"$pref_name\","
  pref_line="user_pref(\"$pref_name\", $pref_value);"
  if ! grep --quiet "^$pref_start" "${user_js_file}"; then
    echo -n $'\n'"$pref_line" >> "$user_js_file"
    echo $'\t'"Successfully added a new preference in $user_js_file."
  elif grep --quiet "^$pref_line$" "$user_js_file"; then
    echo $'\t'"Skipping, preference is already set as expected in $user_js_file."
  else
    sed --in-place "/^$pref_start/c\\$pref_line" "$user_js_file"
    echo $'\t'"Successfully replaced the existing incorrect preference in $user_js_file."
  fi
done
if [ "$total_profiles_found" -eq 0 ]; then
  echo 'No profile folders are found, no changes are made.'
else
  echo "Successfully verified preferences in $total_profiles_found profiles."
fi
# ----------------------------------------------------------


# ----------------------------------------------------------
# --------------Disable Firefox shutdown ping---------------
# ----------------------------------------------------------
echo '--- Disable Firefox shutdown ping'
pref_name='toolkit.telemetry.shutdownPingSender.enabled'
pref_value='false'
echo "Setting preference \"$pref_name\" to \"$pref_value\"."
declare -a profile_paths=(
  ~/.mozilla/firefox/*/
  ~/.var/app/org.mozilla.firefox/.mozilla/firefox/*/
  ~/snap/firefox/common/.mozilla/firefox/*/
)
declare -i total_profiles_found=0
for profile_dir in "${profile_paths[@]}"; do
  if [ ! -d "$profile_dir" ]; then
    continue
  fi
  if [[ ! "$(basename "$profile_dir")" =~ ^[a-z0-9]{8}\..+ ]]; then
    continue # Not a profile folder
  fi
  ((total_profiles_found++))
  user_js_file="${profile_dir}user.js"
  echo "$user_js_file:"
  if [ ! -f "$user_js_file" ]; then
    touch "$user_js_file"
    echo $'\t''Created new user.js file'
  fi
  pref_start="user_pref(\"$pref_name\","
  pref_line="user_pref(\"$pref_name\", $pref_value);"
  if ! grep --quiet "^$pref_start" "${user_js_file}"; then
    echo -n $'\n'"$pref_line" >> "$user_js_file"
    echo $'\t'"Successfully added a new preference in $user_js_file."
  elif grep --quiet "^$pref_line$" "$user_js_file"; then
    echo $'\t'"Skipping, preference is already set as expected in $user_js_file."
  else
    sed --in-place "/^$pref_start/c\\$pref_line" "$user_js_file"
    echo $'\t'"Successfully replaced the existing incorrect preference in $user_js_file."
  fi
done
if [ "$total_profiles_found" -eq 0 ]; then
  echo 'No profile folders are found, no changes are made.'
else
  echo "Successfully verified preferences in $total_profiles_found profiles."
fi
pref_name='toolkit.telemetry.shutdownPingSender.enabledFirstSession'
pref_value='false'
echo "Setting preference \"$pref_name\" to \"$pref_value\"."
declare -a profile_paths=(
  ~/.mozilla/firefox/*/
  ~/.var/app/org.mozilla.firefox/.mozilla/firefox/*/
  ~/snap/firefox/common/.mozilla/firefox/*/
)
declare -i total_profiles_found=0
for profile_dir in "${profile_paths[@]}"; do
  if [ ! -d "$profile_dir" ]; then
    continue
  fi
  if [[ ! "$(basename "$profile_dir")" =~ ^[a-z0-9]{8}\..+ ]]; then
    continue # Not a profile folder
  fi
  ((total_profiles_found++))
  user_js_file="${profile_dir}user.js"
  echo "$user_js_file:"
  if [ ! -f "$user_js_file" ]; then
    touch "$user_js_file"
    echo $'\t''Created new user.js file'
  fi
  pref_start="user_pref(\"$pref_name\","
  pref_line="user_pref(\"$pref_name\", $pref_value);"
  if ! grep --quiet "^$pref_start" "${user_js_file}"; then
    echo -n $'\n'"$pref_line" >> "$user_js_file"
    echo $'\t'"Successfully added a new preference in $user_js_file."
  elif grep --quiet "^$pref_line$" "$user_js_file"; then
    echo $'\t'"Skipping, preference is already set as expected in $user_js_file."
  else
    sed --in-place "/^$pref_start/c\\$pref_line" "$user_js_file"
    echo $'\t'"Successfully replaced the existing incorrect preference in $user_js_file."
  fi
done
if [ "$total_profiles_found" -eq 0 ]; then
  echo 'No profile folders are found, no changes are made.'
else
  echo "Successfully verified preferences in $total_profiles_found profiles."
fi
pref_name='toolkit.telemetry.firstShutdownPing.enabled'
pref_value='false'
echo "Setting preference \"$pref_name\" to \"$pref_value\"."
declare -a profile_paths=(
  ~/.mozilla/firefox/*/
  ~/.var/app/org.mozilla.firefox/.mozilla/firefox/*/
  ~/snap/firefox/common/.mozilla/firefox/*/
)
declare -i total_profiles_found=0
for profile_dir in "${profile_paths[@]}"; do
  if [ ! -d "$profile_dir" ]; then
    continue
  fi
  if [[ ! "$(basename "$profile_dir")" =~ ^[a-z0-9]{8}\..+ ]]; then
    continue # Not a profile folder
  fi
  ((total_profiles_found++))
  user_js_file="${profile_dir}user.js"
  echo "$user_js_file:"
  if [ ! -f "$user_js_file" ]; then
    touch "$user_js_file"
    echo $'\t''Created new user.js file'
  fi
  pref_start="user_pref(\"$pref_name\","
  pref_line="user_pref(\"$pref_name\", $pref_value);"
  if ! grep --quiet "^$pref_start" "${user_js_file}"; then
    echo -n $'\n'"$pref_line" >> "$user_js_file"
    echo $'\t'"Successfully added a new preference in $user_js_file."
  elif grep --quiet "^$pref_line$" "$user_js_file"; then
    echo $'\t'"Skipping, preference is already set as expected in $user_js_file."
  else
    sed --in-place "/^$pref_start/c\\$pref_line" "$user_js_file"
    echo $'\t'"Successfully replaced the existing incorrect preference in $user_js_file."
  fi
done
if [ "$total_profiles_found" -eq 0 ]; then
  echo 'No profile folders are found, no changes are made.'
else
  echo "Successfully verified preferences in $total_profiles_found profiles."
fi
# ----------------------------------------------------------


# ----------------------------------------------------------
# -------------Disable Firefox new profile ping-------------
# ----------------------------------------------------------
echo '--- Disable Firefox new profile ping'
pref_name='toolkit.telemetry.newProfilePing.enabled'
pref_value='false'
echo "Setting preference \"$pref_name\" to \"$pref_value\"."
declare -a profile_paths=(
  ~/.mozilla/firefox/*/
  ~/.var/app/org.mozilla.firefox/.mozilla/firefox/*/
  ~/snap/firefox/common/.mozilla/firefox/*/
)
declare -i total_profiles_found=0
for profile_dir in "${profile_paths[@]}"; do
  if [ ! -d "$profile_dir" ]; then
    continue
  fi
  if [[ ! "$(basename "$profile_dir")" =~ ^[a-z0-9]{8}\..+ ]]; then
    continue # Not a profile folder
  fi
  ((total_profiles_found++))
  user_js_file="${profile_dir}user.js"
  echo "$user_js_file:"
  if [ ! -f "$user_js_file" ]; then
    touch "$user_js_file"
    echo $'\t''Created new user.js file'
  fi
  pref_start="user_pref(\"$pref_name\","
  pref_line="user_pref(\"$pref_name\", $pref_value);"
  if ! grep --quiet "^$pref_start" "${user_js_file}"; then
    echo -n $'\n'"$pref_line" >> "$user_js_file"
    echo $'\t'"Successfully added a new preference in $user_js_file."
  elif grep --quiet "^$pref_line$" "$user_js_file"; then
    echo $'\t'"Skipping, preference is already set as expected in $user_js_file."
  else
    sed --in-place "/^$pref_start/c\\$pref_line" "$user_js_file"
    echo $'\t'"Successfully replaced the existing incorrect preference in $user_js_file."
  fi
done
if [ "$total_profiles_found" -eq 0 ]; then
  echo 'No profile folders are found, no changes are made.'
else
  echo "Successfully verified preferences in $total_profiles_found profiles."
fi
# ----------------------------------------------------------


# ----------------------------------------------------------
# ---------------Disable Firefox update ping----------------
# ----------------------------------------------------------
echo '--- Disable Firefox update ping'
pref_name='toolkit.telemetry.updatePing.enabled'
pref_value='false'
echo "Setting preference \"$pref_name\" to \"$pref_value\"."
declare -a profile_paths=(
  ~/.mozilla/firefox/*/
  ~/.var/app/org.mozilla.firefox/.mozilla/firefox/*/
  ~/snap/firefox/common/.mozilla/firefox/*/
)
declare -i total_profiles_found=0
for profile_dir in "${profile_paths[@]}"; do
  if [ ! -d "$profile_dir" ]; then
    continue
  fi
  if [[ ! "$(basename "$profile_dir")" =~ ^[a-z0-9]{8}\..+ ]]; then
    continue # Not a profile folder
  fi
  ((total_profiles_found++))
  user_js_file="${profile_dir}user.js"
  echo "$user_js_file:"
  if [ ! -f "$user_js_file" ]; then
    touch "$user_js_file"
    echo $'\t''Created new user.js file'
  fi
  pref_start="user_pref(\"$pref_name\","
  pref_line="user_pref(\"$pref_name\", $pref_value);"
  if ! grep --quiet "^$pref_start" "${user_js_file}"; then
    echo -n $'\n'"$pref_line" >> "$user_js_file"
    echo $'\t'"Successfully added a new preference in $user_js_file."
  elif grep --quiet "^$pref_line$" "$user_js_file"; then
    echo $'\t'"Skipping, preference is already set as expected in $user_js_file."
  else
    sed --in-place "/^$pref_start/c\\$pref_line" "$user_js_file"
    echo $'\t'"Successfully replaced the existing incorrect preference in $user_js_file."
  fi
done
if [ "$total_profiles_found" -eq 0 ]; then
  echo 'No profile folders are found, no changes are made.'
else
  echo "Successfully verified preferences in $total_profiles_found profiles."
fi
# ----------------------------------------------------------


# ----------------------------------------------------------
# ----------------Disable Firefox prio ping-----------------
# ----------------------------------------------------------
echo '--- Disable Firefox prio ping'
pref_name='toolkit.telemetry.prioping.enabled'
pref_value='false'
echo "Setting preference \"$pref_name\" to \"$pref_value\"."
declare -a profile_paths=(
  ~/.mozilla/firefox/*/
  ~/.var/app/org.mozilla.firefox/.mozilla/firefox/*/
  ~/snap/firefox/common/.mozilla/firefox/*/
)
declare -i total_profiles_found=0
for profile_dir in "${profile_paths[@]}"; do
  if [ ! -d "$profile_dir" ]; then
    continue
  fi
  if [[ ! "$(basename "$profile_dir")" =~ ^[a-z0-9]{8}\..+ ]]; then
    continue # Not a profile folder
  fi
  ((total_profiles_found++))
  user_js_file="${profile_dir}user.js"
  echo "$user_js_file:"
  if [ ! -f "$user_js_file" ]; then
    touch "$user_js_file"
    echo $'\t''Created new user.js file'
  fi
  pref_start="user_pref(\"$pref_name\","
  pref_line="user_pref(\"$pref_name\", $pref_value);"
  if ! grep --quiet "^$pref_start" "${user_js_file}"; then
    echo -n $'\n'"$pref_line" >> "$user_js_file"
    echo $'\t'"Successfully added a new preference in $user_js_file."
  elif grep --quiet "^$pref_line$" "$user_js_file"; then
    echo $'\t'"Skipping, preference is already set as expected in $user_js_file."
  else
    sed --in-place "/^$pref_start/c\\$pref_line" "$user_js_file"
    echo $'\t'"Successfully replaced the existing incorrect preference in $user_js_file."
  fi
done
if [ "$total_profiles_found" -eq 0 ]; then
  echo 'No profile folders are found, no changes are made.'
else
  echo "Successfully verified preferences in $total_profiles_found profiles."
fi
# ----------------------------------------------------------


# Disable collection of technical and interaction data in Firefox
echo '--- Disable collection of technical and interaction data in Firefox'
pref_name='datareporting.healthreport.uploadEnabled'
pref_value='false'
echo "Setting preference \"$pref_name\" to \"$pref_value\"."
declare -a profile_paths=(
  ~/.mozilla/firefox/*/
  ~/.var/app/org.mozilla.firefox/.mozilla/firefox/*/
  ~/snap/firefox/common/.mozilla/firefox/*/
)
declare -i total_profiles_found=0
for profile_dir in "${profile_paths[@]}"; do
  if [ ! -d "$profile_dir" ]; then
    continue
  fi
  if [[ ! "$(basename "$profile_dir")" =~ ^[a-z0-9]{8}\..+ ]]; then
    continue # Not a profile folder
  fi
  ((total_profiles_found++))
  user_js_file="${profile_dir}user.js"
  echo "$user_js_file:"
  if [ ! -f "$user_js_file" ]; then
    touch "$user_js_file"
    echo $'\t''Created new user.js file'
  fi
  pref_start="user_pref(\"$pref_name\","
  pref_line="user_pref(\"$pref_name\", $pref_value);"
  if ! grep --quiet "^$pref_start" "${user_js_file}"; then
    echo -n $'\n'"$pref_line" >> "$user_js_file"
    echo $'\t'"Successfully added a new preference in $user_js_file."
  elif grep --quiet "^$pref_line$" "$user_js_file"; then
    echo $'\t'"Skipping, preference is already set as expected in $user_js_file."
  else
    sed --in-place "/^$pref_start/c\\$pref_line" "$user_js_file"
    echo $'\t'"Successfully replaced the existing incorrect preference in $user_js_file."
  fi
done
if [ "$total_profiles_found" -eq 0 ]; then
  echo 'No profile folders are found, no changes are made.'
else
  echo "Successfully verified preferences in $total_profiles_found profiles."
fi
# ----------------------------------------------------------


# ----------------------------------------------------------
# -----Disable detailed telemetry collection in Firefox-----
# ----------------------------------------------------------
echo '--- Disable detailed telemetry collection in Firefox'
pref_name='toolkit.telemetry.enabled'
pref_value='false'
echo "Setting preference \"$pref_name\" to \"$pref_value\"."
declare -a profile_paths=(
  ~/.mozilla/firefox/*/
  ~/.var/app/org.mozilla.firefox/.mozilla/firefox/*/
  ~/snap/firefox/common/.mozilla/firefox/*/
)
declare -i total_profiles_found=0
for profile_dir in "${profile_paths[@]}"; do
  if [ ! -d "$profile_dir" ]; then
    continue
  fi
  if [[ ! "$(basename "$profile_dir")" =~ ^[a-z0-9]{8}\..+ ]]; then
    continue # Not a profile folder
  fi
  ((total_profiles_found++))
  user_js_file="${profile_dir}user.js"
  echo "$user_js_file:"
  if [ ! -f "$user_js_file" ]; then
    touch "$user_js_file"
    echo $'\t''Created new user.js file'
  fi
  pref_start="user_pref(\"$pref_name\","
  pref_line="user_pref(\"$pref_name\", $pref_value);"
  if ! grep --quiet "^$pref_start" "${user_js_file}"; then
    echo -n $'\n'"$pref_line" >> "$user_js_file"
    echo $'\t'"Successfully added a new preference in $user_js_file."
  elif grep --quiet "^$pref_line$" "$user_js_file"; then
    echo $'\t'"Skipping, preference is already set as expected in $user_js_file."
  else
    sed --in-place "/^$pref_start/c\\$pref_line" "$user_js_file"
    echo $'\t'"Successfully replaced the existing incorrect preference in $user_js_file."
  fi
done
if [ "$total_profiles_found" -eq 0 ]; then
  echo 'No profile folders are found, no changes are made.'
else
  echo "Successfully verified preferences in $total_profiles_found profiles."
fi
# ----------------------------------------------------------


# ----------------------------------------------------------
# ----------Disable archiving of Firefox telemetry----------
# ----------------------------------------------------------
echo '--- Disable archiving of Firefox telemetry'
pref_name='toolkit.telemetry.archive.enabled'
pref_value='false'
echo "Setting preference \"$pref_name\" to \"$pref_value\"."
declare -a profile_paths=(
  ~/.mozilla/firefox/*/
  ~/.var/app/org.mozilla.firefox/.mozilla/firefox/*/
  ~/snap/firefox/common/.mozilla/firefox/*/
)
declare -i total_profiles_found=0
for profile_dir in "${profile_paths[@]}"; do
  if [ ! -d "$profile_dir" ]; then
    continue
  fi
  if [[ ! "$(basename "$profile_dir")" =~ ^[a-z0-9]{8}\..+ ]]; then
    continue # Not a profile folder
  fi
  ((total_profiles_found++))
  user_js_file="${profile_dir}user.js"
  echo "$user_js_file:"
  if [ ! -f "$user_js_file" ]; then
    touch "$user_js_file"
    echo $'\t''Created new user.js file'
  fi
  pref_start="user_pref(\"$pref_name\","
  pref_line="user_pref(\"$pref_name\", $pref_value);"
  if ! grep --quiet "^$pref_start" "${user_js_file}"; then
    echo -n $'\n'"$pref_line" >> "$user_js_file"
    echo $'\t'"Successfully added a new preference in $user_js_file."
  elif grep --quiet "^$pref_line$" "$user_js_file"; then
    echo $'\t'"Skipping, preference is already set as expected in $user_js_file."
  else
    sed --in-place "/^$pref_start/c\\$pref_line" "$user_js_file"
    echo $'\t'"Successfully replaced the existing incorrect preference in $user_js_file."
  fi
done
if [ "$total_profiles_found" -eq 0 ]; then
  echo 'No profile folders are found, no changes are made.'
else
  echo "Successfully verified preferences in $total_profiles_found profiles."
fi
# ----------------------------------------------------------


# ----------------------------------------------------------
# ------------Disable Firefox unified telemetry-------------
# ----------------------------------------------------------
echo '--- Disable Firefox unified telemetry'
pref_name='toolkit.telemetry.unified'
pref_value='false'
echo "Setting preference \"$pref_name\" to \"$pref_value\"."
declare -a profile_paths=(
  ~/.mozilla/firefox/*/
  ~/.var/app/org.mozilla.firefox/.mozilla/firefox/*/
  ~/snap/firefox/common/.mozilla/firefox/*/
)
declare -i total_profiles_found=0
for profile_dir in "${profile_paths[@]}"; do
  if [ ! -d "$profile_dir" ]; then
    continue
  fi
  if [[ ! "$(basename "$profile_dir")" =~ ^[a-z0-9]{8}\..+ ]]; then
    continue # Not a profile folder
  fi
  ((total_profiles_found++))
  user_js_file="${profile_dir}user.js"
  echo "$user_js_file:"
  if [ ! -f "$user_js_file" ]; then
    touch "$user_js_file"
    echo $'\t''Created new user.js file'
  fi
  pref_start="user_pref(\"$pref_name\","
  pref_line="user_pref(\"$pref_name\", $pref_value);"
  if ! grep --quiet "^$pref_start" "${user_js_file}"; then
    echo -n $'\n'"$pref_line" >> "$user_js_file"
    echo $'\t'"Successfully added a new preference in $user_js_file."
  elif grep --quiet "^$pref_line$" "$user_js_file"; then
    echo $'\t'"Skipping, preference is already set as expected in $user_js_file."
  else
    sed --in-place "/^$pref_start/c\\$pref_line" "$user_js_file"
    echo $'\t'"Successfully replaced the existing incorrect preference in $user_js_file."
  fi
done
if [ "$total_profiles_found" -eq 0 ]; then
  echo 'No profile folders are found, no changes are made.'
else
  echo "Successfully verified preferences in $total_profiles_found profiles."
fi
# ----------------------------------------------------------


# ----------------------------------------------------------
# -------------Clear Firefox telemetry user ID--------------
# ----------------------------------------------------------
echo '--- Clear Firefox telemetry user ID'
pref_name='toolkit.telemetry.cachedClientID'
pref_value='""'
echo "Setting preference \"$pref_name\" to \"$pref_value\"."
declare -a profile_paths=(
  ~/.mozilla/firefox/*/
  ~/.var/app/org.mozilla.firefox/.mozilla/firefox/*/
  ~/snap/firefox/common/.mozilla/firefox/*/
)
declare -i total_profiles_found=0
for profile_dir in "${profile_paths[@]}"; do
  if [ ! -d "$profile_dir" ]; then
    continue
  fi
  if [[ ! "$(basename "$profile_dir")" =~ ^[a-z0-9]{8}\..+ ]]; then
    continue # Not a profile folder
  fi
  ((total_profiles_found++))
  user_js_file="${profile_dir}user.js"
  echo "$user_js_file:"
  if [ ! -f "$user_js_file" ]; then
    touch "$user_js_file"
    echo $'\t''Created new user.js file'
  fi
  pref_start="user_pref(\"$pref_name\","
  pref_line="user_pref(\"$pref_name\", $pref_value);"
  if ! grep --quiet "^$pref_start" "${user_js_file}"; then
    echo -n $'\n'"$pref_line" >> "$user_js_file"
    echo $'\t'"Successfully added a new preference in $user_js_file."
  elif grep --quiet "^$pref_line$" "$user_js_file"; then
    echo $'\t'"Skipping, preference is already set as expected in $user_js_file."
  else
    sed --in-place "/^$pref_start/c\\$pref_line" "$user_js_file"
    echo $'\t'"Successfully replaced the existing incorrect preference in $user_js_file."
  fi
done
if [ "$total_profiles_found" -eq 0 ]; then
  echo 'No profile folders are found, no changes are made.'
else
  echo "Successfully verified preferences in $total_profiles_found profiles."
fi
# ----------------------------------------------------------


# ----------------------------------------------------------
# -------Enable dynamic First-Party Isolation (dFPI)--------
# ----------------------------------------------------------
echo '--- Enable dynamic First-Party Isolation (dFPI)'
pref_name='network.cookie.cookieBehavior'
pref_value='5'
echo "Setting preference \"$pref_name\" to \"$pref_value\"."
declare -a profile_paths=(
  ~/.mozilla/firefox/*/
  ~/.var/app/org.mozilla.firefox/.mozilla/firefox/*/
  ~/snap/firefox/common/.mozilla/firefox/*/
)
declare -i total_profiles_found=0
for profile_dir in "${profile_paths[@]}"; do
  if [ ! -d "$profile_dir" ]; then
    continue
  fi
  if [[ ! "$(basename "$profile_dir")" =~ ^[a-z0-9]{8}\..+ ]]; then
    continue # Not a profile folder
  fi
  ((total_profiles_found++))
  user_js_file="${profile_dir}user.js"
  echo "$user_js_file:"
  if [ ! -f "$user_js_file" ]; then
    touch "$user_js_file"
    echo $'\t''Created new user.js file'
  fi
  pref_start="user_pref(\"$pref_name\","
  pref_line="user_pref(\"$pref_name\", $pref_value);"
  if ! grep --quiet "^$pref_start" "${user_js_file}"; then
    echo -n $'\n'"$pref_line" >> "$user_js_file"
    echo $'\t'"Successfully added a new preference in $user_js_file."
  elif grep --quiet "^$pref_line$" "$user_js_file"; then
    echo $'\t'"Skipping, preference is already set as expected in $user_js_file."
  else
    sed --in-place "/^$pref_start/c\\$pref_line" "$user_js_file"
    echo $'\t'"Successfully replaced the existing incorrect preference in $user_js_file."
  fi
done
if [ "$total_profiles_found" -eq 0 ]; then
  echo 'No profile folders are found, no changes are made.'
else
  echo "Successfully verified preferences in $total_profiles_found profiles."
fi
# ----------------------------------------------------------


# ----------------------------------------------------------
# -----------Enable Firefox network partitioning------------
# ----------------------------------------------------------
echo '--- Enable Firefox network partitioning'
pref_name='privacy.partition.network_state'
pref_value='true'
echo "Setting preference \"$pref_name\" to \"$pref_value\"."
declare -a profile_paths=(
  ~/.mozilla/firefox/*/
  ~/.var/app/org.mozilla.firefox/.mozilla/firefox/*/
  ~/snap/firefox/common/.mozilla/firefox/*/
)
declare -i total_profiles_found=0
for profile_dir in "${profile_paths[@]}"; do
  if [ ! -d "$profile_dir" ]; then
    continue
  fi
  if [[ ! "$(basename "$profile_dir")" =~ ^[a-z0-9]{8}\..+ ]]; then
    continue # Not a profile folder
  fi
  ((total_profiles_found++))
  user_js_file="${profile_dir}user.js"
  echo "$user_js_file:"
  if [ ! -f "$user_js_file" ]; then
    touch "$user_js_file"
    echo $'\t''Created new user.js file'
  fi
  pref_start="user_pref(\"$pref_name\","
  pref_line="user_pref(\"$pref_name\", $pref_value);"
  if ! grep --quiet "^$pref_start" "${user_js_file}"; then
    echo -n $'\n'"$pref_line" >> "$user_js_file"
    echo $'\t'"Successfully added a new preference in $user_js_file."
  elif grep --quiet "^$pref_line$" "$user_js_file"; then
    echo $'\t'"Skipping, preference is already set as expected in $user_js_file."
  else
    sed --in-place "/^$pref_start/c\\$pref_line" "$user_js_file"
    echo $'\t'"Successfully replaced the existing incorrect preference in $user_js_file."
  fi
done
if [ "$total_profiles_found" -eq 0 ]; then
  echo 'No profile folders are found, no changes are made.'
else
  echo "Successfully verified preferences in $total_profiles_found profiles."
fi
# ----------------------------------------------------------


# ----------------------------------------------------------
# ---Disable outdated Firefox First-Party Isolation (FPI)---
# ----------------------------------------------------------
echo '--- Disable outdated Firefox First-Party Isolation (FPI)'
pref_name='privacy.firstparty.isolate'
pref_value='false'
echo "Setting preference \"$pref_name\" to \"$pref_value\"."
declare -a profile_paths=(
  ~/.mozilla/firefox/*/
  ~/.var/app/org.mozilla.firefox/.mozilla/firefox/*/
  ~/snap/firefox/common/.mozilla/firefox/*/
)
declare -i total_profiles_found=0
for profile_dir in "${profile_paths[@]}"; do
  if [ ! -d "$profile_dir" ]; then
    continue
  fi
  if [[ ! "$(basename "$profile_dir")" =~ ^[a-z0-9]{8}\..+ ]]; then
    continue # Not a profile folder
  fi
  ((total_profiles_found++))
  user_js_file="${profile_dir}user.js"
  echo "$user_js_file:"
  if [ ! -f "$user_js_file" ]; then
    touch "$user_js_file"
    echo $'\t''Created new user.js file'
  fi
  pref_start="user_pref(\"$pref_name\","
  pref_line="user_pref(\"$pref_name\", $pref_value);"
  if ! grep --quiet "^$pref_start" "${user_js_file}"; then
    echo -n $'\n'"$pref_line" >> "$user_js_file"
    echo $'\t'"Successfully added a new preference in $user_js_file."
  elif grep --quiet "^$pref_line$" "$user_js_file"; then
    echo $'\t'"Skipping, preference is already set as expected in $user_js_file."
  else
    sed --in-place "/^$pref_start/c\\$pref_line" "$user_js_file"
    echo $'\t'"Successfully replaced the existing incorrect preference in $user_js_file."
  fi
done
if [ "$total_profiles_found" -eq 0 ]; then
  echo 'No profile folders are found, no changes are made.'
else
  echo "Successfully verified preferences in $total_profiles_found profiles."
fi
# ----------------------------------------------------------


# ----------------------------------------------------------
# ------------Enable Firefox tracking protection------------
# ----------------------------------------------------------
echo '--- Enable Firefox tracking protection'
pref_name='privacy.trackingprotection.enabled'
pref_value='true'
echo "Setting preference \"$pref_name\" to \"$pref_value\"."
declare -a profile_paths=(
  ~/.mozilla/firefox/*/
  ~/.var/app/org.mozilla.firefox/.mozilla/firefox/*/
  ~/snap/firefox/common/.mozilla/firefox/*/
)
declare -i total_profiles_found=0
for profile_dir in "${profile_paths[@]}"; do
  if [ ! -d "$profile_dir" ]; then
    continue
  fi
  if [[ ! "$(basename "$profile_dir")" =~ ^[a-z0-9]{8}\..+ ]]; then
    continue # Not a profile folder
  fi
  ((total_profiles_found++))
  user_js_file="${profile_dir}user.js"
  echo "$user_js_file:"
  if [ ! -f "$user_js_file" ]; then
    touch "$user_js_file"
    echo $'\t''Created new user.js file'
  fi
  pref_start="user_pref(\"$pref_name\","
  pref_line="user_pref(\"$pref_name\", $pref_value);"
  if ! grep --quiet "^$pref_start" "${user_js_file}"; then
    echo -n $'\n'"$pref_line" >> "$user_js_file"
    echo $'\t'"Successfully added a new preference in $user_js_file."
  elif grep --quiet "^$pref_line$" "$user_js_file"; then
    echo $'\t'"Skipping, preference is already set as expected in $user_js_file."
  else
    sed --in-place "/^$pref_start/c\\$pref_line" "$user_js_file"
    echo $'\t'"Successfully replaced the existing incorrect preference in $user_js_file."
  fi
done
if [ "$total_profiles_found" -eq 0 ]; then
  echo 'No profile folders are found, no changes are made.'
else
  echo "Successfully verified preferences in $total_profiles_found profiles."
fi
# ----------------------------------------------------------


# Enable Firefox anti-fingerprinting (may break some websites)
echo '--- Enable Firefox anti-fingerprinting (may break some websites)'
pref_name='privacy.resistFingerprinting'
pref_value='true'
echo "Setting preference \"$pref_name\" to \"$pref_value\"."
declare -a profile_paths=(
  ~/.mozilla/firefox/*/
  ~/.var/app/org.mozilla.firefox/.mozilla/firefox/*/
  ~/snap/firefox/common/.mozilla/firefox/*/
)
declare -i total_profiles_found=0
for profile_dir in "${profile_paths[@]}"; do
  if [ ! -d "$profile_dir" ]; then
    continue
  fi
  if [[ ! "$(basename "$profile_dir")" =~ ^[a-z0-9]{8}\..+ ]]; then
    continue # Not a profile folder
  fi
  ((total_profiles_found++))
  user_js_file="${profile_dir}user.js"
  echo "$user_js_file:"
  if [ ! -f "$user_js_file" ]; then
    touch "$user_js_file"
    echo $'\t''Created new user.js file'
  fi
  pref_start="user_pref(\"$pref_name\","
  pref_line="user_pref(\"$pref_name\", $pref_value);"
  if ! grep --quiet "^$pref_start" "${user_js_file}"; then
    echo -n $'\n'"$pref_line" >> "$user_js_file"
    echo $'\t'"Successfully added a new preference in $user_js_file."
  elif grep --quiet "^$pref_line$" "$user_js_file"; then
    echo $'\t'"Skipping, preference is already set as expected in $user_js_file."
  else
    sed --in-place "/^$pref_start/c\\$pref_line" "$user_js_file"
    echo $'\t'"Successfully replaced the existing incorrect preference in $user_js_file."
  fi
done
if [ "$total_profiles_found" -eq 0 ]; then
  echo 'No profile folders are found, no changes are made.'
else
  echo "Successfully verified preferences in $total_profiles_found profiles."
fi
# ----------------------------------------------------------


# Disable WebRTC exposure of your private IP address in Firefox
echo '--- Disable WebRTC exposure of your private IP address in Firefox'
pref_name='media.peerconnection.ice.default_address_only'
pref_value='true'
echo "Setting preference \"$pref_name\" to \"$pref_value\"."
declare -a profile_paths=(
  ~/.mozilla/firefox/*/
  ~/.var/app/org.mozilla.firefox/.mozilla/firefox/*/
  ~/snap/firefox/common/.mozilla/firefox/*/
)
declare -i total_profiles_found=0
for profile_dir in "${profile_paths[@]}"; do
  if [ ! -d "$profile_dir" ]; then
    continue
  fi
  if [[ ! "$(basename "$profile_dir")" =~ ^[a-z0-9]{8}\..+ ]]; then
    continue # Not a profile folder
  fi
  ((total_profiles_found++))
  user_js_file="${profile_dir}user.js"
  echo "$user_js_file:"
  if [ ! -f "$user_js_file" ]; then
    touch "$user_js_file"
    echo $'\t''Created new user.js file'
  fi
  pref_start="user_pref(\"$pref_name\","
  pref_line="user_pref(\"$pref_name\", $pref_value);"
  if ! grep --quiet "^$pref_start" "${user_js_file}"; then
    echo -n $'\n'"$pref_line" >> "$user_js_file"
    echo $'\t'"Successfully added a new preference in $user_js_file."
  elif grep --quiet "^$pref_line$" "$user_js_file"; then
    echo $'\t'"Skipping, preference is already set as expected in $user_js_file."
  else
    sed --in-place "/^$pref_start/c\\$pref_line" "$user_js_file"
    echo $'\t'"Successfully replaced the existing incorrect preference in $user_js_file."
  fi
done
if [ "$total_profiles_found" -eq 0 ]; then
  echo 'No profile folders are found, no changes are made.'
else
  echo "Successfully verified preferences in $total_profiles_found profiles."
fi
# ----------------------------------------------------------


# ----------------------------------------------------------
# -Disable blocking of unstable plugins in Firefox (revert)-
# ----------------------------------------------------------
echo '--- Disable blocking of unstable plugins in Firefox (revert)'
pref_name='browser.safebrowsing.blockedURIs.enabled'
pref_value='false'
echo "Reverting preference: \"$pref_name\" to its default."
if command -v 'ps' &> /dev/null && ps aux | grep -i "[f]irefox" > /dev/null; then
  >&2 echo -e "\e[33mWarning: Firefox is currently running. Please close Firefox before executing the revert script to ensure changes are applied effectively.\e[0m"
fi
declare -a files_to_modify=('prefs.js' 'user.js')
declare -a profile_paths=(
  ~/.mozilla/firefox/*/
  ~/.var/app/org.mozilla.firefox/.mozilla/firefox/*/
  ~/snap/firefox/common/.mozilla/firefox/*/
)
declare -i total_profiles_found=0
for profile_dir in "${profile_paths[@]}"; do
  if [ ! -d "$profile_dir" ]; then
    continue
  fi
  if [[ ! "$(basename "$profile_dir")" =~ ^[a-z0-9]{8}\..+ ]]; then
    continue # Not a profile folder
  fi
  ((total_profiles_found++))
  for file_to_modify in "${files_to_modify[@]}"; do
    config_file_path="${profile_dir}${file_to_modify}"
    if [ ! -f "$config_file_path" ]; then
      continue
    fi
    echo "$config_file_path:"
    pref_start="user_pref(\"$pref_name\","
    pref_line="user_pref(\"$pref_name\", $pref_value);"
    if ! grep --quiet "^$pref_start" "${config_file_path}"; then
      echo $'\t''Skipping, preference was not configured before.'
    elif grep --quiet "^$pref_line$" "${config_file_path}"; then
      sed --in-place "/^$pref_line/d" "$config_file_path"
      echo $'\t''Successfully reverted preference to default.'
      if ! grep --quiet '[^[:space:]]' "$config_file_path"; then
        rm "$config_file_path"
        echo $'\t'"Removed the file as it became empty."
      fi
    else
      echo $'\t''Skipping, the preference has value that is not configured by privacy.sexy.'
    fi
  done
done
if [ "$total_profiles_found" -eq 0 ]; then
  echo 'No reversion was necessary.'
else
  echo "Successfully verified preferences in $total_profiles_found profiles."
fi
# ----------------------------------------------------------


# Disable Firefox application reputation checks for downloads (revert)
echo '--- Disable Firefox application reputation checks for downloads (revert)'
pref_name='browser.safebrowsing.downloads.enabled'
pref_value='false'
echo "Reverting preference: \"$pref_name\" to its default."
if command -v 'ps' &> /dev/null && ps aux | grep -i "[f]irefox" > /dev/null; then
  >&2 echo -e "\e[33mWarning: Firefox is currently running. Please close Firefox before executing the revert script to ensure changes are applied effectively.\e[0m"
fi
declare -a files_to_modify=('prefs.js' 'user.js')
declare -a profile_paths=(
  ~/.mozilla/firefox/*/
  ~/.var/app/org.mozilla.firefox/.mozilla/firefox/*/
  ~/snap/firefox/common/.mozilla/firefox/*/
)
declare -i total_profiles_found=0
for profile_dir in "${profile_paths[@]}"; do
  if [ ! -d "$profile_dir" ]; then
    continue
  fi
  if [[ ! "$(basename "$profile_dir")" =~ ^[a-z0-9]{8}\..+ ]]; then
    continue # Not a profile folder
  fi
  ((total_profiles_found++))
  for file_to_modify in "${files_to_modify[@]}"; do
    config_file_path="${profile_dir}${file_to_modify}"
    if [ ! -f "$config_file_path" ]; then
      continue
    fi
    echo "$config_file_path:"
    pref_start="user_pref(\"$pref_name\","
    pref_line="user_pref(\"$pref_name\", $pref_value);"
    if ! grep --quiet "^$pref_start" "${config_file_path}"; then
      echo $'\t''Skipping, preference was not configured before.'
    elif grep --quiet "^$pref_line$" "${config_file_path}"; then
      sed --in-place "/^$pref_line/d" "$config_file_path"
      echo $'\t''Successfully reverted preference to default.'
      if ! grep --quiet '[^[:space:]]' "$config_file_path"; then
        rm "$config_file_path"
        echo $'\t'"Removed the file as it became empty."
      fi
    else
      echo $'\t''Skipping, the preference has value that is not configured by privacy.sexy.'
    fi
  done
done
if [ "$total_profiles_found" -eq 0 ]; then
  echo 'No reversion was necessary.'
else
  echo "Successfully verified preferences in $total_profiles_found profiles."
fi
# ----------------------------------------------------------


# ----------------------------------------------------------
# -------Disable Firefox malware protection (revert)--------
# ----------------------------------------------------------
echo '--- Disable Firefox malware protection (revert)'
pref_name='browser.safebrowsing.malware.enabled'
pref_value='false'
echo "Reverting preference: \"$pref_name\" to its default."
if command -v 'ps' &> /dev/null && ps aux | grep -i "[f]irefox" > /dev/null; then
  >&2 echo -e "\e[33mWarning: Firefox is currently running. Please close Firefox before executing the revert script to ensure changes are applied effectively.\e[0m"
fi
declare -a files_to_modify=('prefs.js' 'user.js')
declare -a profile_paths=(
  ~/.mozilla/firefox/*/
  ~/.var/app/org.mozilla.firefox/.mozilla/firefox/*/
  ~/snap/firefox/common/.mozilla/firefox/*/
)
declare -i total_profiles_found=0
for profile_dir in "${profile_paths[@]}"; do
  if [ ! -d "$profile_dir" ]; then
    continue
  fi
  if [[ ! "$(basename "$profile_dir")" =~ ^[a-z0-9]{8}\..+ ]]; then
    continue # Not a profile folder
  fi
  ((total_profiles_found++))
  for file_to_modify in "${files_to_modify[@]}"; do
    config_file_path="${profile_dir}${file_to_modify}"
    if [ ! -f "$config_file_path" ]; then
      continue
    fi
    echo "$config_file_path:"
    pref_start="user_pref(\"$pref_name\","
    pref_line="user_pref(\"$pref_name\", $pref_value);"
    if ! grep --quiet "^$pref_start" "${config_file_path}"; then
      echo $'\t''Skipping, preference was not configured before.'
    elif grep --quiet "^$pref_line$" "${config_file_path}"; then
      sed --in-place "/^$pref_line/d" "$config_file_path"
      echo $'\t''Successfully reverted preference to default.'
      if ! grep --quiet '[^[:space:]]' "$config_file_path"; then
        rm "$config_file_path"
        echo $'\t'"Removed the file as it became empty."
      fi
    else
      echo $'\t''Skipping, the preference has value that is not configured by privacy.sexy.'
    fi
  done
done
if [ "$total_profiles_found" -eq 0 ]; then
  echo 'No reversion was necessary.'
else
  echo "Successfully verified preferences in $total_profiles_found profiles."
fi
# ----------------------------------------------------------


# ----------------------------------------------------------
# -------Disable Firefox phishing protection (revert)-------
# ----------------------------------------------------------
echo '--- Disable Firefox phishing protection (revert)'
pref_name='browser.safebrowsing.phishing.enabled'
pref_value='false'
echo "Reverting preference: \"$pref_name\" to its default."
if command -v 'ps' &> /dev/null && ps aux | grep -i "[f]irefox" > /dev/null; then
  >&2 echo -e "\e[33mWarning: Firefox is currently running. Please close Firefox before executing the revert script to ensure changes are applied effectively.\e[0m"
fi
declare -a files_to_modify=('prefs.js' 'user.js')
declare -a profile_paths=(
  ~/.mozilla/firefox/*/
  ~/.var/app/org.mozilla.firefox/.mozilla/firefox/*/
  ~/snap/firefox/common/.mozilla/firefox/*/
)
declare -i total_profiles_found=0
for profile_dir in "${profile_paths[@]}"; do
  if [ ! -d "$profile_dir" ]; then
    continue
  fi
  if [[ ! "$(basename "$profile_dir")" =~ ^[a-z0-9]{8}\..+ ]]; then
    continue # Not a profile folder
  fi
  ((total_profiles_found++))
  for file_to_modify in "${files_to_modify[@]}"; do
    config_file_path="${profile_dir}${file_to_modify}"
    if [ ! -f "$config_file_path" ]; then
      continue
    fi
    echo "$config_file_path:"
    pref_start="user_pref(\"$pref_name\","
    pref_line="user_pref(\"$pref_name\", $pref_value);"
    if ! grep --quiet "^$pref_start" "${config_file_path}"; then
      echo $'\t''Skipping, preference was not configured before.'
    elif grep --quiet "^$pref_line$" "${config_file_path}"; then
      sed --in-place "/^$pref_line/d" "$config_file_path"
      echo $'\t''Successfully reverted preference to default.'
      if ! grep --quiet '[^[:space:]]' "$config_file_path"; then
        rm "$config_file_path"
        echo $'\t'"Removed the file as it became empty."
      fi
    else
      echo $'\t''Skipping, the preference has value that is not configured by privacy.sexy.'
    fi
  done
done
if [ "$total_profiles_found" -eq 0 ]; then
  echo 'No reversion was necessary.'
else
  echo "Successfully verified preferences in $total_profiles_found profiles."
fi
# ----------------------------------------------------------


echo 'Your privacy and security is now hardened 🎉💪'
echo 'Press any key to exit.'
read -n 1 -s
