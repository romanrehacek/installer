#!/bin/sh
wget -O start.sh "https://preview.c9users.io/romanrehacek/installers/installer.sh"

if [ -f start.sh ]; then
    chmod +x start.sh
    ./start.sh
fi