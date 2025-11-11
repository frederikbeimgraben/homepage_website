#!/bin/bash
# This script is used to publish the website to the server

export SERVER="frederik@beimgraben.net"

# Upload to github
## Add all files
git add .

## Commit
git commit -m "Publishing"

## Push
git push

# Call the rebuild script on the server
ssh $SERVER "cd /home/frederik/homepage/home && ./rebuild.sh"