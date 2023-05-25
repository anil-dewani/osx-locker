# osx-locker

![OSX Locker Demonstration](https://media2.giphy.com/media/v1.Y2lkPTc5MGI3NjExMGNkMDA5ZWJiY2QzY2Y4NTg1YmY2YTEzYTU0MjM3MjkzYTkzYmY2ZCZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/pFKldo8me3jZK9uIpC/giphy.gif)

This utility changes password of your current osx user to a random word and notifies you of the new password automatically on the next working day. You will not have access to the newly set password until next working day arrives. 

Usual server and client architecture is being used to code this utility.

Server Side:
An Django web application which keeps a log of all your password changes and its verification status. 

Client side:
An bash shell script to fetch current password from server and set a new random word as password. Once password is changed, it locks you out of your macbook automatically.

A useful utility to bring about a good balance to your work and personal life. Use this utility to lock yourself from your work macbook until next working day so you can shift your focus to other valuable things instead of ruminating and fiddling into your work even after your work hours are over.


Steps to Create Dock Shorcut to execute shell script:
- Open Shortcuts app on your macbook
- Click the '+' sign on the top to create a new shortcut
- Give your shorcut an intuitive name and select an icon
- From right sidebar, select 'Run Shell Script'
- Paste the script located at /scripts/lock.command in this repo
- Select /bin/bash as your shell from dropdown
- Run to test the execution, Allow permissions if prompted
- Go back, right click on your shorcut and select 'Add to Dock'
- Keep using it from your dock to lock your macbook everyday after work!
- Focus on other aspects of your life apart from your work system
