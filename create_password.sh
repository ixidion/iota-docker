#!/bin/bash
USER=
PASSWORD=
SECRET=

echo -n "Enter a secret for ansible: "
read -s SECRET
echo $SECRET > secret
echo
echo "Secret saved to filename: secret. Please store your secret in a safe place."

echo -n "Enter Username for Webserver Login: "
read USER
echo
echo -n Enter Password:
read -s PASSWORD
echo

HTPASSWD="$(htpasswd -n -b -B $USER $PASSWORD)"

ansible-vault encrypt_string --vault-id secret $HTPASSWD --name 'htaccess_username_password' > group_vars/all/secrets.yml
echo
echo Password generated. Please run ansible-playbook with option: --vault-id secret
