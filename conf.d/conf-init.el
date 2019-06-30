;;; Initial settings -*- lexical-binding: t -*-

;; User Info
(let ((name (getenv "USER_FULL_NAME"))
      (mail (getenv "USER_MAIL_ADDRESS")))
  (when name (setq user-full-name name))
  (when mail (setq user-mail-address mail)))

;; Default color setting
(defun my-theme-setting (&optional dark-theme)
  (let ((fg-color (if (or dark-theme (not window-system)) "Gray80" "Black"))
        (bg-color (if (or dark-theme (not window-system)) "Gray23" "Ivory2")))
    (set-face-attribute 'default nil
                        :foreground fg-color :background bg-color)
    (set-face-attribute 'fringe nil
                        :background bg-color)
    (set-face-attribute 'header-line nil
                        :background bg-color :underline nil)
    (set-face-attribute 'vertical-border nil
                        :background bg-color)))
(defun sk-light-theme () (interactive) (my-theme-setting))
(defun sk-dark-theme  () (interactive) (my-theme-setting t))

;; Default dark theme
(my-theme-setting t)

;; y-or-n instead of yes-or-no
(fset 'yes-or-no-p 'y-or-n-p)

;; M-up, M-down, M-left, and M-right keys.
(windmove-default-keybindings 'meta)

;; Remove whitespace before saving the file.
(add-hook 'before-save-hook
          (lambda () (when (derived-mode-p 'prog-mode)
                       (delete-trailing-whitespace))))


;; Prevents custom.el file changes.
(defun package--save-selected-packages (&optional value)
  (when value (setq package-selected-packages value)))

;; use-package setting
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(setq use-package-always-defer t
      use-package-always-ensure t
      use-package-enable-imenu-support t)
(put :map 'lisp-indent-function 'defun)
(require 'use-package)

(require 'conf-general)
(require 'conf-dev)


(provide 'conf-init)
