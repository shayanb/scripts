#!/bin/bash

#Gets the urls that return a status 200 on port 443 when given a list of ips.
#
# Usage: ./ssl.sh ips.txt
#
# By: Leon Teale (RandomStorm)
#


## Check for correct usage
if [ -z "$1" ];
then
echo ""
echo "please provide some ips for the script"
echo "   Usage: ./ssl.sh file.txt"
echo ""
else
echo ""
for ip in `cat $1`;
do echo "$ip";

#Perform nmap to only gather ips that have port 443 open else the script can hang.
nmap $ip -p 443 -o /dev/null | egrep open; done | grep -B 1 open > temp.txt; cat temp.txt | grep '[^\.][0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}[^\.]' > ips443.txt;
for ip in `cat ips443.txt | sort -u`; do

#Performs the last bit of the program using curl to grab the URL
curl -k -sL -w "%{http_code} %{url_effective}\\n" "https://$ip"; done | grep "200 https"
fi

## Tidy up
rm temp.txt
rm ips443.txt
