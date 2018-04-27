;;; Initial settings

(defconst windowsp (eq system-type 'windows-nt) "t : Windows system")

;; User Info
(let ((name (getenv "USER_FULL_NAME"))
      (mail (getenv "USER_MAIL_ADDRESS")))
  (if name (setq user-full-name name))
  (if mail (setq user-mail-address mail)))


;;; Macros
(defmacro add-many-hook (hooks function)
  `(dolist (hook ,hooks)
     (add-hook hook ,function)))


;; use-package setting
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(setq use-package-enable-imenu-support t)
(require 'use-package)

;; mode line setting
(require 'sk-mode-line)
(sk-mode-line)

;; hangul 3bulsik
(setq default-korean-keyboard "3")

(when window-system
  ;; Korean font
  (set-fontset-font t 'hangul (font-spec :name "NanumGothicCoding"))
  ;; background-color : Ivory 2
  (setq default-frame-alist
        (append default-frame-alist '((background-color . "#EEEEE0")))))

(when (and windowsp enable-multibyte-characters)
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
            (lambda (&rest args) (package-initialize)))


(require 'conf-general)
(require 'conf-dev)


(provide 'conf-init)
