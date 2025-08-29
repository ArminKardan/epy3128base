#!/bin/bash

python -c "print('Python container started...')"

if [[ ! -d "/apps/main/repo/$block" ]] || [[ "$rebuild" == "true" ]]; then
    # echo "Cloning github token:${githubtoken}"

    echo 'Hi! Welcome to QE Auto <Python> publisher!'

    if ["$system_install_shell_url" != "null"]
        curl -sL ${system_install_shell_url} | bash
    fi

    if [ "$alpine_packages" != "null" ]; then
        echo 'Installing user alpine-linux packages...'
        apk add --no-cache ${alpine_packages}
    fi

    if [ "$pipinstall" != "null" ]; then
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
        chmod +x install.sh
        ./startup.sh
    fi

    sleep 1
fi

cd /apps/main/repo/${block}

if ["$system_startup_shell_url" != "null"]; then
    curl -sL ${system_startup_shell_url} | bash
fi

if [ -f "startup.sh" ]; then
    chmod +x startup.sh
    ./startup.sh
fi

python run.py
