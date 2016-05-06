# svn-git-sync

This system can synchronize the svn repository with the git repository on the server
in both directions. Hooks in the svn synchronize the new commit from svn to git
and hooks in the git synchonize commits from the git to the svn when develop branch
is pushed.

This system can only synchronize svn trunk with the git develop branch. The svn
repository and the git repository have to be on the same server. It is not absolutely
safe but it is mostly safe when used the right way.

This system is made for the time when you want to slowly switch from the svn to git
but not all users are ready or persuaded to use the git. It is designed to teach
users the [Git Flow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow)
without realease and bugfix branches. It worked in my case.

## Instatalation

Pull this repository and rename the `gitserver/_.git` folder to `gitserver/.git`
and `gitserver/_.gitignore` file to `gitserver/.gitignore`. And make `self2svn.sh`
and `svn2self.sh` executable.

```
chmod +x gitserver/self2svn.sh
chmod +x gitserver/svn2self.sh
```  

Go to the folder where you want to have the git repository and run next commands
to initialize the connection from git to svn. Instead of `file://../svn/trunk`
specify the path to your svn repository. For X in `-rX` specify the revision of svn
where you want to start synchronizing.

```
git init
git svn clone file://../svnserver/trunk . -r1
```

Copy the content of the _gitserver_ folder into your git repository and run next
commands in it to add your _.gitignore_ and synchronize it with svn. 

```
git svn rebase
git checkout -b develop      
git add .gitignore
git commit -m "Add gitignore"
git svn dcommit
git checkout master
git rebase develop
```

Now your git will push its commits to svn when the develop branch will be pushed.
The pushed commits will be always modified, so pull the develop after your push!
Keep your git repository on the server on the master branch!

Now change the 5th row in _svnserver/hooks/pre-commit_ and _svnserver/hooks/post-commit_.
In `cd $(dirname "$0")/../../gitserver` to contain the absolute path to your git
repository or relative path from the hooks folder (just like in example). And now
copy the content of _svnserver_ to your svn server.

Now svn server will be synchronized to git when you make commit in svn. No previous
commit is modified in this proccess.

## Use of git

Make pull after each push of the develop branch. The valid commit message on the
develop branch have to contain **git-svn-id**.

Do not use the master branch! It should be equal with the develop branch after
synchronization.

Do not commit to the develop branch directly.

When you want to create new feature:

1. Pull the develop branch. The last commit have to have the **git-svn-id** in the
commit message.
2. Make new feature branch from the branch develop.
3. Work on the feature branch.
4. When your work is done, do those steps quickly:
  1. Pull the develop branch. The last commit have to have the **git-svn-id** in the
commit message.
  2. Checkout the feature branch and rebase on top of the develop branch.  
  3. Checkout the develop branch and merge (fast forward) the feature branch onto it.
(If you want to add less commits to svn, squash them before merge.)
  4. Pull the develop. If it has been changed, you have to reset your local develop
branch to the common commit of develop and feature branch and repeat whole step
4 again (this is why you have to do it quickly).
  5. Push the develop branch.
  6. Pull the develop branch! The last commit have to have the **git-svn-id** in the
commit message.
  7. Don't ever use the feature branch again, next time just create new.

## How to migrate to git only

1. Turn the svn and git repository off so no one can commit and push to them.
2. Create bare git repository somewhere.
3. Create remote to the new repository in the old one.
4. Push all branches frrom old repository to the new one.
5. Let users to change their remote to the new address.
6. Archive the svn and remove the old git repository (or don't, it's up to you).
7. Teach users about the rest of the 
[Git Flow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow).
They already know they shouldn't use master and commit in the develop and they
know how to make the feature. Teach them about release and hotfix, this
[Git Flow Diagram](http://danielkummer.github.io/git-flow-cheatsheet/) may help.