# OpenVpn-keys
Automate OpenVPN configuration and Keys Generation.

The script makes use of the pkitool to create .cert, .csr and .key files on the OpenVPN server.
The keys along with client.conf are bundled into a zip file for that user and sent to it's email address

Usage: 
Put the script in /etc/openvpn/easy-rsa folder  or run it from that directory.
$ ./gen-key <user-email-address
