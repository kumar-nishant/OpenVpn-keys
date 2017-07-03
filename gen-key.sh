#!/bin/bash

#Change the directory to /etc/openvpn/easy-rsa
cd "${0%/*}"

#Accept email address of the user as an argument to the script 
eml=$1

#extract the User name from the email address
client=${eml%@*}

echo $client 

#Check if the arguments are missing, If so, echo the correct usage format
if [ x$client = x ]; then
    echo "Usage: $0 client-email address"
    exit 1;
fi

#Check if the Keys already exist for that user
if [ ! -e keys/$client.key ]; then
    echo "Generating keys..."
    . vars
    ./pkitool $client
    echo "...keys generated."
else
    echo "keys already exist for user $client" 
fi

zipfile=~/$client.zip

if [ ! -e $zipfile ]; then
    echo "Creating zipfile..."
    tmpdir=~/$client
    mkdir $tmpdir
    cp /home/client.conf $tmpdir/client.conf
    sed -i 's/cert\ \.crt/cert\ '${client}'\.crt/g' $tmpdir/client.conf
    sed -i 's/key\ \.key/key\ '${client}'\.key/g' $tmpdir/client.conf
    cp keys/ca.crt $tmpdir
    cp keys/$client.key $tmpdir/$client.key
    cp keys/$client.crt $tmpdir/$client.crt
    cp keys/$client.csr $tmpdir/$client.csr
    zip -r -j ~/$client.zip $tmpdir
    rm -rf $tmpdir
    echo "Configuration Zipfile created for $eml" 
else
    echo "Nothing to do, so nothing done. ($client.zip already exists)" 
fi

echo "Please unzip and import the attached VPN conifguration to your VPN client." | \
      mutt -e 'set realname="VPN-Manager' -s "VPN Client Configuration" $1 -a $zipfile

echo "$client.zip sent to $eml". 
                                 
