# New machine config

1. Full system update
2. Execute the environment setup script
```bash
    ./scripts/setup-system.sh [e-mail]
    ./scripts/fix-trackpad.sh (only needed with multi-touchs while libinput is sucking...)
```
During the execution of the 'setup-system.sh' script there will be a couple of interuptions
   - SNX install you need to follow the upstream link and download the install script manually
   - After key creations the public key needs to be uploaded to GitHub/Lab... w/e

3. Create dev environment
```bash
   scripts/create-soma-workspace.sh [cepel-user]
```

