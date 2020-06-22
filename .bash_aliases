alias lsa="ls -alrt"
alias vi="vim -O"
alias grep="grep --exclude-dir=\.git --color=always"
alias jq="jq -C"
alias k="kubectl"
alias kg="kubectl get"
alias dre="docker run -ti --rm --entrypoint /bin/sh"

if [ -f /usr/lib/git-core/git-sh-prompt ]; then
  source /usr/lib/git-core/git-sh-prompt
fi

function gl() {
  git log --format=fuller --decorate --color --no-merges
}
function glm() {
  git log --format=fuller --decorate --color
}
function gpd() {
  out=$(git push --dry-run --porcelain origin $1)
  sha=$(echo $out | cut -d ' ' -f 4)
  git show $sha
}
function gcm() {
  git checkout master
  git fetch upstream
  git rebase upstream/master
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
function ggr() {
  git grep -n "$1" .
}
function gcr() {
  git commit --reset-author -c $1
}
function gca() {
  git commit --amend --reset-author -c $1
}

function gcpr() {
  git fetch $1 pull/$2/head:pr-$2
  git checkout pr-$2
}

function cdc() {
  docker images -f "dangling=true" -q | xargs docker rmi -f
  docker rm -v $(docker ps -a -q -f status=exited)
  docker volume ls -f 'dangling=true' -q | xargs docker volume rm
  docker ps -a | egrep 'Exited.*(days|weeks|months)' | awk '{print $1}' | xargs docker rm -v
}

function doocker-host-port() {
  docker inspect $1 --format='{{(index (index .NetworkSettings.Ports "$2/tcp") 0).HostPort}}'
}

function kube-svc-port() {
  kubectl get svc -n $1 -l $2 -o jsonpath='{.items[0].spec.ports[0].port}'
}

function kube-port-forward() {
  kubectl -n $1 port-forward $(kubectl -n $1 get pod -l $2 -o jsonpath='{.items[0].metadata.name}') $3:$4 2>&1 > /dev/null
}

function kube-pod-name() {
  kubectl -n $1 get pods -o custom-columns=:metadata.name --no-headers=true
}

function kube-not-running() {
  kubectl get pods --all-namespaces --no-headers \
    | grep -v "Running"
}

function kube-del-stalled() {
  kubectl get pods --all-namespaces --no-headers \
    | grep -v "Running" \
    | awk '{print $1 " " $2}' \
    | xargs -n2 kubectl delete --grace-period=0 --force pod -n
}

function kube-del-loop() {
  for i in $(seq $1 $2); do kubectl delete ns $3-$i; done
}

function kube-sort-age() {
  kubectl -n $1 get pods --sort-by=.status.startTime
}

function helm-del-purge() {
  helm ls | grep -E $1 \
    | awk '{print $1}' \
    | xargs -n1 helm delete --purge
}

function kube-del-resources() {
  kubectl get $1 --no-headers \
    | awk '{print $1}' \
    | xargs -n1 kubectl delete $1
}

function fetchIstioCert() {
  kubectl get secrets -n $1 $2 -o json | \
    jq -r '.data["ca-cert.pem"]' | \
    base64 -D | \
    openssl x509 -text -noout
}

function ku() {
  kops update cluster --create-kube-config=false
}

function kuy() {
  kops update cluster --create-kube-config=false --yes
}

function updateImageTag() {
  find $1 -name *.yaml | xargs sed -i.bak -e "s/$2/$3/g"
  find $1 -name *.yaml.bak | xargs rm
}

# Istio aliases
function istio-listener() {
  istioctl pc listeners $1 --address $2 --port $3 -o json
}

function istio-route() {
  istioctl pc routes $1 --name $2 -o json
}

function istio-cluster() {
  istioctl pc clusters $1 --fqdn $2 -o json
}

_direnv_prompt () {
  if [[ "$PROMPT_NAME" != "" ]]; then
    printf "(%s)" "${PROMPT_NAME}"
  elif [[ "$DIRENV_DIR" =~ -/.* ]]; then
    printf "(%s)" "$(basename ${DIRENV_DIR#-})"
  fi
}

PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$(__git_ps1 "(%s)")\$ '
PS1='$(_direnv_prompt)'"$PS1"

# Generate cscope database
function cscope_build() {
  # Generate a list of all source files starting from the current directory
  # The -o means logical or
  find . -name "*.c" -o -name "*.cc" -o -name "*.cpp" -o -name "*.h" -o -name "*.hh" -o -name "*.hpp" > cscope.files
  # -q build fast but larger database
  # -R search symbols recursively
  # -b build the database only, don't fire cscope
  # -i file that contains list of file paths to be processed
  # This will generate a few cscope.* files
  cscope -q -R -b -i cscope.files
  # Temporary files, remove them
  # rm -f cscope.files cscope.in.out cscope.po.out
  echo "The cscope database is generated"
}

json_escape () {
    printf '%s' "$1" | python -c 'import json,sys; print(json.dumps(sys.stdin.read()))'
}

function urlencode() {
  echo "$1" | jq -sRr @uri
  echo "Trim the trailing %0A"
}
