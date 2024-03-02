#!/bin/sh

sudo -v || { echo 'Incorrect password'; exit 1; }

echo 'New password: \c'
read -r password
echo "Result: $password"
