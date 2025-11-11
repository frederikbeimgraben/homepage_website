#!/bin/bash
# This is executed on the server to rebuild the website

# Change to the website directory
cd /home/frederik/homepage/home

# Pull from github
git pull

# Rebuild the website
hugo

# Copy google ownership file
cp google*.html public/