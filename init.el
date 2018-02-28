;; SK Emacs Setting

(let ((file-name-handler-alist nil)
      (gc-cons-threshold most-positive-fixnum))

  (package-initialize)
  (setq package-archives
        '(("gnu" . "https://elpa.gnu.org/packages/")
          ("melpa" . "https://melpa.milkbox.net/packages/")))

  (add-to-list 'load-path "~/.emacs.d/conf.d/")
  (add-to-list 'load-path "~/.emacs.d/conf.d/sk-utils/")

  ;; custom file
  (setq custom-file "~/.emacs.d/custom.el")
  (load custom-file)

  (require 'conf-init))
