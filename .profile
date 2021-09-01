SSHAGENT=`which ssh-agent`
SSHAGENTARGS="-s"
if [ -z "$SSH_AUTH_SOCK" -a -x "$SSHAGENT" ]; then
    eval `$SSHAGENT $SSHAGENTARGS`
    trap "kill $SSH_AGENT_PID" 0
fi
export PATH="/usr/local/opt/python/libexec/bin:/usr/local/go/bin:/usr/local/bin:$HOME/.krew/bin:$PATH"
export WORKON_HOME=~/.virtualenvs
export EDITOR="vim"

if [ -f $HOME/.ssh/id_rsa_github ] &&
   ! ssh-add -l | grep -q $HOME/.ssh/id_rsa_github; then
  ssh-add $HOME/.ssh/id_rsa_github
fi
