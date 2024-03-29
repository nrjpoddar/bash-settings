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


### Setting up bash-completion & Git prompt in Mac OSX
You need additional setup for getting the prompt working correctly in
Mac OSX:

* Install brew:
  ```bash
    /usr/bin/ruby -e "$(curl -fsSL \
      https://raw.githubusercontent.com/Homebrew/install/master/install)"
  ```
* Install bash-completion
  ```bash
    brew install bash-completion
  ```
* Install Git from brew
  ```bash
    brew install git
  ```
* Close and restart the terminal, your prompt will include the Git branch if the
  current directory is a Git workspace.

### Making bash your default shell
In newer versions of MAC OS, zsh is the default shell instead of bash. You can
use the following commands to switch to the latest version of bash as your
default login shell.

1. Install latest bash:
   ```bash
     brew install bash
   ```
1. Add newly bash to list of shells. Note that the MAC OS default bash is quite old.
   ```bash
     echo /usr/local/bin/bash | sudo tee -a /etc/shells
   ```
1. Switch to bash as default login
   ```bash
     chsh -s /usr/local/bin/bash
   ```

### Setting up direnv in Mac OSX
Install direnv using brew:
```bash
  brew install direnv
```
Your prompt will include the environment which is currently being used by
direnv.

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
