# New machine config

1. Full system update
2. Install packages from arch repos
    sudo packages/install-apps.sh
    packages/install-aur.sh
3. Create dev folders and download misc software
    sudo scripts/setup-dev.sh
4. Link configuration files
    cd stow
    (probably needs a script to remove existing stuff)
    stow -vt ~ *
5. Create a new SSH key, upload it do github and test it.
    scripts/create-ssh-keys.sh
    ssh -T git@github.com
6. Install vscode extensions
    vscode/install-extensions.sh
7. Download eclipse and extract to
    ~/dev/applications/eclipse
8. Clone soma projects
    cd ~/dev/soma/
    git clone git@github.com:SOMA-App/soma-container.git
    git clone git@github.com:SOMA-App/soma-web-container.git (* verify scripts)
9. Development servers - given the sensitive content of some files this step need to be completed manually for now



