#!/bin/bash

wget -q https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb
apt update
apt install sysmonforlinux socat nginx -y
/opt/sysinternalsEBPF/libsysinternalsEBPFinstaller -i
sysmon -i
