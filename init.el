;; SK Emacs Setting -*- lexical-binding: t -*-

(let ((file-name-handler-alist nil)
      (gc-cons-threshold most-positive-fixnum))

  (if (not window-system)
      (custom-set-variables '(menu-bar-mode nil)
                            '(scroll-bar-mode nil)
                            '(tool-bar-mode nil))
    (add-to-list 'default-frame-alist '(menu-bar-lines . 0))
    (add-to-list 'default-frame-alist '(tool-bar-lines . 0))
    (add-to-list 'default-frame-alist '(vertical-scroll-bars)))

  (when (member "-init" command-line-args)
    (let ((output-buffer (generate-new-buffer "*Init*")))
      (delete "-init" command-line-args)
      (switch-to-buffer output-buffer)
      (call-process "emacs" nil  output-buffer t
                    "-l" "~/.emacs.d/install.el" "-batch" "-init")))

  (package-initialize)
  (setq package-archives
        '(("gnu"   . "http://elpa.gnu.org/packages/")
          ("melpa" . "http://melpa.org/packages/")
          ("org"   . "https://orgmode.org/elpa/")))

  (add-to-list 'load-path "~/.emacs.d/conf.d/")
  (add-to-list 'load-path "~/.emacs.d/conf.d/sk-utils/")

  ;; custom file
  (setq custom-file "~/.emacs.d/custom.el")
  (load custom-file)

  (require 'conf-init)

  ;; after init
  (setq package--initialized nil))
