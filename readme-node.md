>This script clones the nvm repository into ~/.nvm. Then it updates your profile (~/.bash_profile, ~/.zshrc, ~/.profile, or ~/.bashrc) to source the nvm.sh it contains.

```bash

source ~/.bashrc
source ~/.zshrc
source ~/.profile

```

### select node version to install

```bash
nvm list-remote  #list remote node
nvm list 
nvm install <version> # like: 14.17.6


nvm install --lts  #last version tls

nvm install v16.14.0

nvm use v16.14.0
nvm alias default 16.14.2
nvm use default
```


#more info https://github.com/nvm-sh/nvm