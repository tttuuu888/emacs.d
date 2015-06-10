;; Initial Setting

(defconst win32p  (eq system-type 'windows-nt) "T if Windows system")
(defconst unixp   (eq system-type (or 'gnu/linux 'gnu/kfreebsd)) "T if Linux system")

;; Install packages if not installed
(require 'cl)
(defvar installing-package-list
  '( ;; list of packages
    auto-complete
    auto-complete-c-headers
    magit
    git-commit-mode
    git-rebase-mode
    ggtags
    xcscope
    python-mode
    jedi
    redo+
    slime
    ac-slime
    avy
    helm
    helm-ag
    helm-git
    helm-git-files
    helm-git-grep
    helm-projectile
    projectile
    markdown-mode
    markdown-toc
    clojure-mode
    cider
    ac-cider
;    ac-cider-compliment
    paredit
    chicken-scheme
    geiser
    ac-geiser
    expand-region
    powerline
    stickyfunc-enhance
    yasnippet
    use-package
    key-chord
    ))

(when win32p
    (push 'cygwin-mount installing-package-list))

(let ((not-installed (loop for x in installing-package-list
                        when (not (package-installed-p x))
                        collect x)))
  (when not-installed
    (package-refresh-contents)
    (dolist (pkg not-installed)
      (package-install pkg))))

(require 'use-package)
