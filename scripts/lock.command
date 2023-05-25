#!/usr/bin/env bash

# Add values below to configure script

osx_username=""
master_password=""
endpoint_domain=""

# Do Not Change anything below unless needed

password_endpoint_url="${endpoint_domain}lock-the-mac/new-password/?username=${osx_username}"

function prompt() {
  osascript <<EOT
    tell app "System Events"
      text returned of (display dialog "$1" with icon caution default answer "$2" buttons {"I will Relax now!"} default button 1 with title "End Of The Day")
    end tell
EOT
}

value="$(prompt 'Please type yes to confirm logging out' '')"

if [[ $value != "yes"  ]] ; then
  osascript -e 'display dialog "You did not type 'yes' - please retry"'
  exit 0
fi

endpoint_response=$(curl -s "$password_endpoint_url")
IFS=',' read -ra password_array <<< "$endpoint_response"

old_password="${password_array[0]}"
new_password="${password_array[1]}"

if [ ! -n "$old_password" ]; then
  echo "No Old Password Detected. exiting."
  exit 0
fi

if [ ! -n "$new_password" ]; then
  echo "No New Password Detected. exiting."
  exit 0
fi

dscl . -passwd /Users/$osx_username $old_password $new_password

if [ $? -eq 0 ]; then
    verification_endpoint_url="${endpoint_domain}lock-the-mac/verify-password/?username=${osx_username}&password=${new_password}"
    verification_response=$(curl -s -w "%{http_code}" "$verification_endpoint_url")
    
    http_code=$(tail -n1 <<< "$verification_response")

    if [[ $http_code == 200  ]] ; then
        osascript -e 'tell application "System Events" to keystroke "q" using {control down, command down}'
    else
        echo "Some problem with verification. Setting password to your master password."
        dscl . -passwd /Users/$osx_username $new_password $master_password
    fi
else
    echo "Error while changing password."
fi