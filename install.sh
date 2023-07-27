#!/bin/sh
cp ./laptoptd.service /etc/systemd/system/
dub build
cp ./laptoptd /bin/
systemctl enable --now laptoptd.service