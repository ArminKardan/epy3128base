#!/bin/bash

python -c "print('<<<Python container started.>>>')"

if [[ ! -d "/apps/main/repo/$block" ]] || [[ "$rebuild" == "true" ]]; then
    # echo "Cloning github token:${githubtoken}"

    echo 'Hi! Welcome to QE Auto <Python> publisher!'

    pip install ${pipinstall}

    git clone -n --filter=tree:0 --sparse ${giturl} /apps/main/repo
    sleep 1
    cd /apps/main/repo
    git sparse-checkout init --no-cone                        
    git sparse-checkout set /${block}/
    git checkout main

    sleep 1

    cd /apps/main/repo/${block}

    sleep 1
fi

cd /apps/main/repo/${block}

python run.py
