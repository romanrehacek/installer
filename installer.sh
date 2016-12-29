#!/bin/sh

# Copyright 2016 Roman Rehacek
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#wget https://preview.c9users.io/romanrehacek/installers/x.sh -v -O install.sh && chmod +x install.sh && ./install.sh; rm -rf install.sh

echo "\033[44mDeleting unnecessary files and folders\033[m\n"
if [ -f README.md ]; then
    rm README.md
fi

if [ -f php.ini ]; then
    rm php.ini
fi

if [ -f hello-world.php ]; then
    rm hello-world.php
fi

if [ -d wordpress ]; then
    rm -rf wordpress
fi

echo "\033[44mInit npm...\033[m\n"
npm init -f

echo "\033[44mInstall gulp...\033[m\n"
npm install gulp -g
npm install --save-dev gulp

echo "\033[44mInstall gulp packages...\033[m\n"
npm install --save-dev gulp-less gulp-rename gulp-clean-css gulp-uglify stream-combiner2 gulp-watch gulp-util pretty-hrtime gulp-concat inquirer find-in-files

echo "\033[44mDownload gulpfile.js...\033[m\n"
wget "https://raw.githubusercontent.com/romanrehacek/gulpfile/master/gulpfile.js" -N -q

if [ -f gulpfile.js ]; then
    echo "\033[42mDownload success.\033[m"
else
    echo "\n\033[41mERROR: gulpfile.js didn't downloaded!\033[m\n"
    exit
fi

echo -n "\n\033[41mEnter path to theme\033[m etc. './wp-content/themes/name/' (leave blank for './'): "
read path

# Set default value
path=${path:-./}

# remove last slash if exists
path=$(echo "$path"|sed 's/\/$//g')

# add slash as last char
path=$path"/"

# Replace path in gulpfile.js
sed -i "s/\[enter_path\]/$(echo $path | sed -e 's/[\/&]/\\&/g')/g" gulpfile.js

if [ -d "wp-includes" ]; then
    echo -n "\n\033[41mInstall new theme? [y/n]:\033[m "
    read new_theme
    
    if test "$new_theme" = "y"; then
        echo "\033[44mDownload .htaccess...\033[m\n"
        wget "https://raw.githubusercontent.com/romanrehacek/starter-commands/master/.htaccess" -N -q
        
        dirName=$(basename "$path")
        
        pathToTheme=$(echo $path | sed 's!'"$dirName"'.*!!g')
        
        if test "$pathToTheme" != ""; then
            rm -R -- ${pathToTheme}* 
            wget "https://github.com/romanrehacek/default-wp-theme/archive/master.zip" -N -q
            if [ ! -f master.zip ]; then
                echo "\n\033[41mERROR: master.zip didn't downloaded!\033[m\n"
                exit
            fi
            unzip master.zip -d $pathToTheme
            rm master.zip
            mv ${pathToTheme}default-wp-theme-master ${pathToTheme}${dirName}
            
            echo -n "\n\033[41mEnter theme name\033[m (leave blank for 'Example theme'): "
            read themeName
            
            echo -n "\n\033[41mEnter site domain\033[m (leave blank for 'example.com'): "
            read domainName
            
            sed -i "s/\[theme_name\]/$(echo $themeName | sed -e 's/[\/&]/\\&/g')/g" ${pathToTheme}${dirName}/style.css
            sed -i "s/\[domain_name\]/$(echo $domainName | sed -e 's/[\/&]/\\&/g')/g" ${pathToTheme}${dirName}/style.css
            sed -i "s/\[dir_name\]/$(echo $dirName | sed -e 's/[\/&]/\\&/g')/g" ${pathToTheme}${dirName}/style.css
        fi
    fi
fi

if [ -f start.sh ]; then
    rm start.sh
fi

echo "\033[44mInstall Git WebUI...\033[m\n"
cd $HOME
rm -rf .git-webui > /dev/null 2>&1
echo "Cloning git-webui repository"
git clone --depth 1 https://github.com/alberthier/git-webui.git .git-webui
echo "Enabling auto update"
git config --global --replace-all webui.autoupdate true
echo "Installing 'webui' alias"
if [ "$OS" = "Windows_NT" ]; then
    git config --global --replace-all alias.webui "!${PYTHON} $HOME/.git-webui/release/libexec/git-core/git-webui"
else
    git config --global --replace-all alias.webui !$HOME/.git-webui/release/libexec/git-core/git-webui
fi

#END
echo -n "\n\033[42mAll done.\033[m\n"
