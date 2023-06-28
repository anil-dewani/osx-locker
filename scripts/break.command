#!/usr/bin/env bash

# Add values below to configure script

osx_username="{YOUR_SYSTEM_USERNAME}"
master_password="{YOUR_MASTER_PASSWORD}"
endpoint_domain="{YOUR_SERVER_ENDPOINT}"
break_time_minutes=15
last_event="sleep" # can pass any one of two values: "shutdown" or "sleep"

# Do Not Change anything below unless needed

password_endpoint_url="${endpoint_domain}lock-the-mac/new-password/?username=${osx_username}"

endpoint_response=$(curl -s "$password_endpoint_url")
IFS=',' read -ra password_array <<< "$endpoint_response"

old_password="${password_array[0]}"
new_password="${password_array[1]}"

if [ ! -n "$old_password" ]; then
  echo "No Old Password Detected. Exiting."
  osascript -e 'display dialog "Some problem with old password detection. Please continue to use your old password of your system or debug your server." buttons {"Ok"} default button 1 with title "End of Day"'
  exit 0
fi

if [ ! -n "$new_password" ]; then
  echo "No New Password Detected. Exiting."
  osascript -e 'display dialog "Some problem with new password detection. Please continue to use your old password of your system or debug your server." buttons {"Ok"} default button 1 with title "End of Day"'
  exit 0
fi

dscl . -passwd /Users/$osx_username $old_password $new_password
security set-keychain-password -o $old_password -p  $new_password "/Users/$osx_username/Library/Keychains/login.keychain"

if [ $? -eq 0 ]; then
    verification_endpoint_url="${endpoint_domain}lock-the-mac/verify-password/?username=${osx_username}&password=${new_password}&break=${break_time_minutes}"
    verification_response=$(curl -s -w "%{http_code}" "$verification_endpoint_url")
    
    http_code=$(tail -n1 <<< "$verification_response")

    if [[ $http_code == 200  ]] ; then
        if [[ $last_event == "shutdown" ]] ; then
          osascript -e 'tell app "System Events" to shut down'
        elif [[ $last_event == "sleep" ]] ; then
          osascript -e 'tell application "System Events" to keystroke "q" using {control down, command down}'
        else
          echo "Incorrect or no value passed in last_event config variable"
          osascript -e 'display dialog "Incorrect or no value passed in last_event config variable" buttons {"Ok"} default button 1 with title "End of Day"'
        fi
    else
        echo "Some problem with password verification. Setting password to your master password."
        dscl . -passwd /Users/$osx_username $new_password $master_password
        security set-keychain-password -o $old_password -p  $new_password "/Users/$osx_username/Library/Keychains/login.keychain"
    fi
else
    echo "Some problem with password change. Please continue to use your old password of your system."
fi