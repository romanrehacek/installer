#!/bin/sh
wget -O start.sh "https://raw.githubusercontent.com/romanrehacek/installer/master/installer.sh"

if [ -f start.sh ]; then
    chmod +x start.sh
    ./start.sh
fi