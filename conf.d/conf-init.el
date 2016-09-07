;; Initial settings

(defconst win32p (eq system-type 'windows-nt) "t : Windows system")
(defconst unixp  (eq system-type (or 'gnu/linux 'gnu/kfreebsd)) "t : Linux system")

;; hangul 3bulsik
(setq default-korean-keyboard "3")

;; Korean font
(if window-system (set-fontset-font t 'hangul (font-spec :name "NanumGothicCoding")))

;; Korean letter setting for Windows
(when (and win32p enable-multibyte-characters)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)
  (prefer-coding-system 'utf-8)
  (set-file-name-coding-system 'euc-kr))

;; y-or-n instead of yes-or-no
(fset 'yes-or-no-p 'y-or-n-p)

;; background-color : Ivory 2
(if window-system (set-background-color "#EEEEE0"))

;;  M-up, M-down, M-left, and M-right keys.
(windmove-default-keybindings 'meta)

(remove-hook 'find-file-hooks 'vc-find-file-hook)

(require 'conf-general)
(require 'conf-dev)


(provide 'conf-init)
