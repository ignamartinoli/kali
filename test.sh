#!/bin/sh

# sudo -v || { echo 'Incorrect password'; exit 1; }
echo 'sans sudo && mit IFS'

echo 'New password: \c'
IFS= read -r password
echo "Result: $password"
