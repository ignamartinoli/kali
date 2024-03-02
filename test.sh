#!/bin/sh

# sudo -v || { echo 'Incorrect password'; exit 1; }
echo 'sans sudo'

echo 'New password: \c'
read -r password
echo "Result: $password"
