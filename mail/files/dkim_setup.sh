#!/bin/bash

mkdir -p /etc/opendkim/keys/$1
cd /etc/opendkim/keys/$1; opendkim-genkey -t -s mail -d $1 && tr -d "\n\t\\\" " < mail.txt | cut -d"(" -f2 | cut -d ")" -f1 | tee /root/dkim.txt; chown opendkim:opendkim mail.private
echo mail._domainkey.$1 $1:mail:/etc/opendkim/keys/$1/mail.private | tee /etc/opendkim/KeyTable
echo *@$1 mail._domainkey.$1 | tee /etc/opendkim/SigningTable
echo SOCKET="inet:12345@localhost" | tee -a /etc/default/opendkim
echo *.$1 | tee -a /etc/opendkim/TrustedHosts
echo localhost | tee -a /etc/opendkim/TrustedHosts
echo 127.0.0.1 | tee -a /etc/opendkim/TrustedHosts
