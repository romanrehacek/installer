#!/bin/sh
wget -O start.sh "https://github.com/romanrehacek/installer/installer.sh"

if [ -f start.sh ]; then
    chmod +x start.sh
    ./start.sh
fi