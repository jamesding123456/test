#!/bin/bash


if [ $# -ne 4 ]; then

    echo "Usage: $0 'Full Name' 'Username' 'Password' 'FTP Directory'"

    exit 1

fi




FULLNAME="$1"

USERNAME="$2"

PASSWORD="$3"

FTPDIR="$4"

USER_HOME="/ftp"

FTPSHELL="/bin/ftpsh"




if [ "$(id -u)" -ne 0 ]; then

    echo "Please run as root"

    exit 1

fi




if id "$USERNAME" &>/dev/null; then

    echo "User '$USERNAME' already exists, skipping useradd and password set"

else

    echo "Creating user '$USERNAME' ..."

    useradd -d "$USER_HOME" -g 1001 -s "$FTPSHELL" -c "$FULLNAME" "$USERNAME"

    echo "$USERNAME:$PASSWORD" | chpasswd

fi





if [ ! -d "$FTPDIR" ]; then

    echo "Creating directory: $FTPDIR"

    mkdir -p "$FTPDIR"
    chown "$USERNAME":"$USERNAME" "$FTPDIR"
    setfacl -m u:$USERNAME:rwx "$FTPDIR"
    chmod 770 "$FTPDIR"
    chgrp guestftp "$FTPDIR"
else
    setfacl -m u:$USERNAME:rwx "$FTPDIR"
fi










echo "FTP user configuration completed!"

echo "--------------------------------"

echo "Full Name : $FULLNAME"

echo "Username  : $USERNAME"

if id "$USERNAME" &>/dev/null; then

    echo "Password  : (unchanged)"

else

    echo "Password  : $PASSWORD"

fi

echo "Home Dir  : $USER_HOME"

echo "FTP Dir   : $FTPDIR"

echo "Shell     : $FTPSHELL"

echo "--------------------------------"
