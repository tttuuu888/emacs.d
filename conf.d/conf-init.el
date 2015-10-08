;; Initial settings

(defconst win32p  (eq system-type 'windows-nt) "T if Windows system")
(defconst unixp   (eq system-type (or 'gnu/linux 'gnu/kfreebsd)) "T if Linux system")

;;Python Path
(if unixp
    (setenv "PYTHONPATH" "/usr/local/bin/ipython")
    (setenv "PYTHONPATH" "C:/home/util/Python27"))

;; Lisp Path
(if unixp
    (setq inferior-lisp-program "/usr/bin/clisp")
    ;;(setq inferior-lisp-program "/usr/bin/sbcl")
    (setq inferior-lisp-program "C:/home/util/clisp-2.49/clisp"))

;; hangul 3bulsik
(setq default-korean-keyboard "3")

;; Korean font
(set-fontset-font "fontset-default" '(#x1100 . #xffdc)
                  '("NanumGothicOTF" . "iso10646-1"))
(set-fontset-font "fontset-default" '(#xe0bc . #xf66e)
                  '("NanumGothicOTF" . "iso10646-1"))

;; Korean letter setting
(when (and enable-multibyte-characters win32p)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)
  (prefer-coding-system 'utf-8)
  (set-file-name-coding-system 'euc-kr))


;; In terminal mode, change color of minibuffer prompt to green
(if window-system
    (global-hl-line-mode t)
    (set-face-foreground 'minibuffer-prompt "green"))

;; y-or-n instead of yes-or-no
(fset 'yes-or-no-p 'y-or-n-p)

;;  M-up, M-down, M-left, and M-right keys.
(windmove-default-keybindings 'meta)

(use-package bind-key
    :ensure t
    :config
    (unbind-key "C-z")
    (bind-key "C-x C-r" 'recentf-open-files))

(use-package conf-general)
(use-package conf-dev)


(provide 'conf-init)
