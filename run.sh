#!/bin/bash

python -c "print('Python container started...')"

if [[ ! -d "/apps/main/repo/$block" ]] || [[ "$rebuild" == "true" ]]; then
    # echo "Cloning github token:${githubtoken}"

    echo 'Hi! Welcome to QE Auto Python 3.12.8 publisher!'

    if [["$system_install_shell_url" != "null"]]; then
        echo 'Running system install script...'
        curl -sL ${system_install_shell_url} | bash
    fi

    if [[ "$alpine_packages" != "null" ]]; then
        echo 'Installing user alpine-linux packages...'
        apk add --no-cache ${alpine_packages}
    fi

    if [[ "$pipinstall" != "null" ]]; then
        echo 'Installing user python packages...'
        pip install ${pipinstall}
    fi

    git clone -n --filter=tree:0 --sparse ${giturl} /apps/main/repo
    sleep 1
    cd /apps/main/repo
    git sparse-checkout init --no-cone                        
    git sparse-checkout set /${block}/
    git checkout main

    sleep 1

    cd /apps/main/repo/${block}

    if [ -f "install.sh" ]; then
        echo 'Running install shell script...'
        chmod +x install.sh
        ./startup.sh
    fi

    sleep 1
fi

cd /apps/main/repo/${block}

if [["$system_startup_shell_url" != "null"]]; then
    echo 'Running system startup script...'
    curl -sL ${system_startup_shell_url} | bash
fi

if [ -f "startup.sh" ]; then
    echo 'Running startup shell script...'
    chmod +x startup.sh
    ./startup.sh
fi
echo 'Running python worker...'
python run.py
