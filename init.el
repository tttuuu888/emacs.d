;; SK Emacs Setting

(package-initialize)
(setq package-archives
      '(("ELPA" . "http://tromey.com/elpa/")
        ("gnu" . "http://elpa.gnu.org/packages/")
        ("marmalade" . "https://marmalade-repo.org/packages/")
        ("melpa" . "http://melpa.milkbox.net/packages/")))


;; init-loader
(when (not (package-installed-p 'init-loader))
  (package-refresh-contents)
  (package-install 'init-loader))

(require 'init-loader)
(setq init-loader-show-log-after-init 'error-only)
(init-loader-load "~/.emacs.d/conf.d/")


;; custom file
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)


(recentf-open-files)
