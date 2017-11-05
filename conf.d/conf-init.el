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

(when (and windowsp enable-multibyte-characters)
  (prefer-coding-system 'utf-8))

;; y-or-n instead of yes-or-no
(fset 'yes-or-no-p 'y-or-n-p)

;;  M-up, M-down, M-left, and M-right keys.
(windmove-default-keybindings 'meta)

;; To prevent custom.el file changed.
(defun package--save-selected-packages (&optional value)
  (when value (setq package-selected-packages value)))


(require 'conf-general)
(require 'conf-dev)


;; To prevent abnormal behavior of package-list-packages.
(setq package--initialized nil)


(provide 'conf-init)
