#!/bin/sh
#
# An example hook script to verify what is about to be committed.
# Called by "git commit" with no arguments.  The hook should
# exit with non-zero status after issuing an appropriate message if
# it wants to stop the commit.
#
# To enable this hook, rename this file to "pre-commit".

while [ -f .sync ]
do
	echo "Already synchronizing"
	sleep 1s
done

touch .sync
touch .syncd
unset GIT_DIR
git checkout develop
git svn rebase
git svn dcommit
git checkout master
git rebase develop
rm .syncd
rm .sync