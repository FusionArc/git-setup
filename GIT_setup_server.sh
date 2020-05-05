!# /bin/bash
export PROJECTSLUG="cloudshare"
export GIT_SLUG="${PROJECTSLUG}.git"
export GIT_REPO="${HOME}/${PROJECTSLUG}/repo/${GIT_SLUG}/"
export GIT_WORK_TREE="${HOME}/${PROJECTSLUG}/src/"
export REMOTE="https://github.com/FusionArc/cloudshare.git"
export PATH=${HOME}/.local/bin:$PATH
echo 'Creating working directory and git repo...'
mkdir -p $GIT_WORK_TREE
mkdir -p $GIT_REPO 
cat <<GIT >> ${HOME}/.gitignore
[core]
    user.name David Barrow
    user.email dave@fusion-arc.uk
GIT
## For new project
# git --work-tree=$GIT_WORK_TREE --git-dir=$GIT_REPO clone $REMOTE--bare

### For existing project 
cd $GIT_REPO && git clone $REMOTE . --bare
git --work-tree=${GIT_WORK_TREE} --git-dir=${GIT_REPO} checkout -f
# cd $HOME/$PROJECTSLUG/ && virtualenv -p python3.8 venv
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
