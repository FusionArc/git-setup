!# /bin/bash
export PROJECTSLUG="cloudshare"
export GIT_SLUG="${PROJECTSLUG}.git"
export GIT_REPO="${HOME}/${PROJECTSLUG}/repo/${GIT_SLUG}/"
export GIT_WORK_TREE="${HOME}/${PROJECTSLUG}/src/"
export REMOTE="https://github.com/FusionArc/${PROJECTSLUG}"
export PATH=${HOME}/.local/bin:$PATH
echo 'Creating working directory and git repo...'
sudo chown -R $HOME $USER
mkdir -p $GIT_WORK_TREE
mkdir -p $GIT_REPO 
sudo apt install python3-virtualenv
cat <<GIT >> ${HOME}/.gitconfig
[user]
	name = David Barrow
	email = dave@fusion-arc.uk
[core]
	editor = vscode-server
	whitespace = fix,-indent-with-non-tab,trailing-space,cr-at-eol
[color]
	ui = true
[color "branch"]
	current = yellow bold
	local = green bold
	remote = cyan bold
[color "diff"]
	meta = yellow bold
	frag = magenta bold
	old = red bold
	new = green bold
	whitespace = red reverse
[color "status"]
	added = green bold
	changed = yellow bold
	untracked = red bold
GIT
## For new project
# git --work-tree=$GIT_WORK_TREE --git-dir=$GIT_REPO clone $REMOTE--bare

### For existing project 
cd $GIT_REPO && git clone $REMOTE . --bare
git --work-tree=${GIT_WORK_TREE} --git-dir=${GIT_REPO} checkout -f
cd $HOME/$PROJECTSLUG/ 
virtualenv -p python3 venv
export VENV_BIN="${HOME}/${PROJECTSLUG}/venv/bin"
$VENV_BIN/python -m pip install -r $HOME/$PROJECTSLUG/src/requirements.txt

cat <<EOT >> $GIT_REPO/hooks/post-receive
!#bin/bash
git --work-tree=${GIT_WORK_TREE} --git-dir=${GIT_REPO} checkout -f
EOT

chmod +x $HOME/$GIT_REPO/hooks/post-receive

echo "Success. You can access your project on your server at:"
echo "Be sure to run this on your local repo:"
echo "git remote add live ssh://${USER}@${PROJECTSLUG}:${GIT_REPO}"
