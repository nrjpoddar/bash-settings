alias lsa="ls -alrt"
alias vi="vim -O"
alias grep="grep --exclude-dir=\.git --color=always"

if [ -f /usr/lib/git-core/git-sh-prompt ]; then
  source /usr/lib/git-core/git-sh-prompt
fi

function gl() {
  git log --format=fuller --decorate --color --no-merges
}
function gpd() {
  git push --dry-run origin $1
}
function gp() {
  git push origin $1
}
function grb() {
  git fetch $1
  git rebase $1/$2
}
function gd() {
  git diff
}
function gdc() {
  git diff --cached
}
function gs() {
  git status
}
function gsh() {
  git show $1
}
function gst() {
  git stash show -p stash@{$1}
}
function gsa() {
  git stash apply stash@{$1}
}
function gr() {
  grep -r -n "$1" .
}
function gcr() {
  git commit --reset-author -c $1
}
function gca() {
  git commit --amend --reset-author -c $1
}

function cdc() {
  docker images -f "dangling=true" -q | xargs docker rmi -f
  docker rm -v $(docker ps -a -q -f status=exited)
  docker volume ls -f 'dangling=true' -q | xargs docker volume rm
  docker ps -a | egrep 'Exited.*(days|weeks|months)' | awk '{print $1}' | xargs docker rm -v
}

_direnv_prompt () {
  if [[ "$PROMPT_NAME" != "" ]]; then
    printf "(%s)" "${PROMPT_NAME}"
  elif [[ "$DIRENV_DIR" =~ -/.* ]]; then
    printf "(%s)" "$(basename ${DIRENV_DIR#-})"
  fi
}

PS1='${debian_chroot:+($debian_chroot)}\033[01;32m\]\u@\h\033[00m\]:[\033[01;34m\]\w\[\033[00m\]] $(__git_ps1 "(%s)")\$ '
PS1='$(_direnv_prompt)'"$PS1"
