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
	if [ -f .syncd ]
	then
		exit 0
	fi
	echo "Already synchronizing"
	sleep 1s
done

touch .sync
git checkout develop
git svn rebase
git checkout master
git rebase develop
rm .sync