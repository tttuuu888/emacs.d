;;; Initial settings -*- lexical-binding: t -*-

;; User Info
(let ((name (getenv "USER_FULL_NAME"))
      (mail (getenv "USER_MAIL_ADDRESS")))
  (when name (setq user-full-name name))
  (when mail (setq user-mail-address mail)))

;; Hangul 3bulsik
(setq default-korean-keyboard "3")

;; Korean font
(when window-system
    (set-fontset-font t 'hangul (font-spec :name "D2Coding")))

;; Default color setting
(let ((default-foreground-color (if window-system "Black"  "LightGray"))
      (default-background-color (if window-system "Ivory2" "Gray18")))
  (set-face-attribute 'default nil
                      :background default-background-color
                      :foreground default-foreground-color)
  (set-face-attribute 'line-number-current-line nil
                      :weight 'bold)
  (set-face-attribute 'fringe nil
                      :background default-background-color)
  (set-face-attribute 'vertical-border nil
                      :background default-background-color))

(when (and (eq system-type 'windows-nt) enable-multibyte-characters)
  (prefer-coding-system 'utf-8))

;; y-or-n instead of yes-or-no
(fset 'yes-or-no-p 'y-or-n-p)

;; M-up, M-down, M-left, and M-right keys.
(windmove-default-keybindings 'meta)

;; Remove whitespace before save file.
(add-hook 'before-save-hook
          (lambda () (when (derived-mode-p 'prog-mode)
                       (delete-trailing-whitespace))))

;; global-auto-revert-mode
(add-hook 'find-file-hook
          (lambda () (when (not (global-auto-revert-mode))
                       (global-auto-revert-mode t))))

;; To prevent custom.el file changed.
(defun package--save-selected-packages (&optional value)
  (when value (setq package-selected-packages value)))

;; To prevent abnormal behavior of package-list-packages.
(advice-add 'package-list-packages :before
            (lambda (&rest _) (package-initialize)))

;; use-package setting
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(setq use-package-always-defer t
      use-package-always-ensure t
      use-package-enable-imenu-support t)
(require 'use-package)

(require 'conf-general)
(require 'conf-dev)


(provide 'conf-init)
