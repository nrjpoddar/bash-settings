This repository contains common bash settings useful in developer workflow.

## Usage
Clone this repository and create following symlinks. (This assumes repository was
cloned under `$HOME`)
```bash
ln -s $HOME/bash-settings/.bash_aliases $HOME/.bash_aliases
ln -s $HOME/bash-settings/.profile $HOME/.profile
ln -s $HOME/bash-settings/.bashrc $HOME/.bashrc
ln -s $HOME/bash-settings/.bash_profile $HOME/.bash_profile
```

### Setting up SSH keys for Github/Gitlab
```bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

Add the key to SSH agent in ~/.bash_profile
```bash
if [ -f $HOME/.ssh/<github/gitlab_private_key ] &&
 ! ssh-add -l | grep -q $HOME/.ssh/<github/gitlab_private_key; then
  ssh-add $HOME/.ssh/<github/gitlab_private_key
fi
```
