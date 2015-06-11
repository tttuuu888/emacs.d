# SK Emacs setting #
This is my personal Emacs setting.  

## Setup ##
    git clone https://github.com/tttuuu888/emacs.d.git ~/.emacs.d
Packages are automatically installed when you start emacs.  
(Try restart a couple of times more, if it's not done at once.)  
  
Copy `.emacs.d/conf.d/0001_path.el.bak` file to `0001_path.el` and set your path on it.
Especially if you are on Windows, below programs should be under your path to use all features of my emacs setting.  
    * git / global / gtags / cscope / cscope-indexer  
    * python / lein  

## Packages ##
    * auto-complete / auto-complete-c-headers  
    * magit / git-commit-mode / git-rebase-mode  
    * ggtags / xcscope  
    * python-mode / jedi  
    * redo+  
    * slime / ac-slime  
    * avy  
    * helm / helm-ag / helm-git / helm-git-files / helm-git-grep / helm-projectile  
    * projectile  
    * markdown-mode / markdown-toc  
    * clojure-mode / cider / ac-cider / paredit  
    * chicken-scheme / geiser / ac-geiser  
    * expand-region  
    * powerline  
    * stickyfunc-enhance  
    * yasnippet
    * use-package
    * key-chord

## Dependencies ##
- **GNU Global** for ggtags (apt-get install global)
- **silversearcher-ag** for helm-ag (apt-get install silversearcher-ag)
- **virtualev** for jedi ( pip install virtualenv )
- **cygwin** for cygwin-mount.  
	If you don't use cygwin on Windows, edit `conf.d/0900_cygwin.el` file as below:  
	```
	(when win32p (defvar cygwin-use nil))
	```
