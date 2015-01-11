# SK Emacs setting #
This is my personal Emacs setting.

## Setup ##
    git clone https://github.com/tttuuu888/.emacs.d.git
Packages are automatically installed when you start emacs.
(Try restart a couple of times more, if it's not done at once.)

## Packages ##
    * auto-complete
    * magit / git-commit-mode / git-rebase-mode
    * ggtags / xcscope
    * python-mode / jedi
    * redo+
    * slime / ac-slime
    * ace-jump-mode
    * helm / helm-git / helm-git-files / helm-git-grep
    * markdown-mode / markdown-toc
    * clojure-mode / cider / ac-cider / ac-cider-compliment / paredit
    * expand-region

## Dependencies ##

#### Python : ####
    pip install virtualenv

#### Cygwin : ####
If you don't use cygwin on Windows, edit `conf.d/0500_cygwin.el` file as below:

    (when win32p (defvar cygwin-use nil))
