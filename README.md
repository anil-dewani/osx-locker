# osx-locker

This utility changes password of your current osx user to a random word and notifies you of the new password automatically on the next working day. You will not have access to the newly set password until next working day arrives. 

Usual server and client architecture is being used to code this utility.

Server Side:
An Django web application which keeps a log of all your password changes and its verification status. 

Client side:
An bash shell script to fetch current password from server and set a new random word as password. Once password is changed, it locks you out of your macbook automatically.

A useful utility to bring about a good balance to your work and personal life. Use this utility to lock yourself from your work macbook until next working day so you can shift your focus to other valuable things instead of ruminating and fiddling into your work even after your work hours are over.
