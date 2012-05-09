#!/bin/bash
for d in local remote; do
  mkdir $d
  cd $d
  git init
  cd -
done

# This hack on the remote makese the master not checked out.
# This could be done less disgustingly.
cd remote
echo '[receive]' >> .git/config
echo 'denyCurrentBranch = ignore' >> .git/config
cd -

# Ordinary local workflow
cd local
echo rm -rf / > fungame.sh
git add fungame.sh
git commit -m 'Fun game'
git push ../remote/.git master
cd -

# What happens if there's a conflict?
function conflict {
  echo remote > remote/$1
  (
    cd local
    echo local > $1
    git add $1
    git commit $1 -m $1
  )
  (
    cd local
    git push ../remote/.git master
  )
}
function check_conflict {
  echo
  echo When these were created, they were \'local\' and \'remote\'
  cat local/$1 remote/$1
  echo
}


echo 1. We could just do nothing about it.
conflict chainsaw
echo The tree has been updated, but not the working directory
check_conflict chainsaw


echo 2. We could overwrite the remote
conflict vibratory_soil_compactor
# Post-receive hook
(
  cd remote
  git reset --hard
  #git clean -f
)
check_conflict vibratory_soil_compactor

echo 3. We could notice that there would be a conflict and not allow it.
echo 
echo I haven\'t figured out how to do this yet.
echo 

echo 4. We could start a new branch decending from the remote
echo '   'If we get merge crap, we report the branch name so someone can fix this.
echo
echo I haven\'t figured out how to do this yet.
echo 
