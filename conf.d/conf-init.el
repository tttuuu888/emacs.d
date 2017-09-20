;;; Initial settings

(defconst windowsp (eq system-type 'windows-nt) "t : Windows system")

;; hangul 3bulsik
(setq default-korean-keyboard "3")

(when window-system
  ;; Korean font
  (set-fontset-font t 'hangul (font-spec :name "NanumGothicCoding"))
  ;; background-color : Ivory 2
  (setq default-frame-alist
        (append default-frame-alist '((background-color . "#EEEEE0")))))

;; Korean letter setting for Windows
(when (and windowsp enable-multibyte-characters)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)
  (prefer-coding-system 'utf-8)
  (set-file-name-coding-system 'euc-kr))

;; y-or-n instead of yes-or-no
(fset 'yes-or-no-p 'y-or-n-p)

;;  M-up, M-down, M-left, and M-right keys.
(windmove-default-keybindings 'meta)

;; To be removed after emacs updated.
(defun package--save-selected-packages (&rest opt) nil)


(require 'conf-general)
(require 'conf-dev)


;; To be removed after emacs updated.
(setq package--initialized nil)


(provide 'conf-init)
