;; Initial settings

(defconst win32p (eq system-type 'windows-nt) "t : Windows system")
(defconst unixp  (eq system-type (or 'gnu/linux 'gnu/kfreebsd)) "t : Linux system")

;; Set 'HOME' environment variable in Windows.

;; Python Path
(if unixp
    (setenv "PYTHONPATH" "/usr/bin/env ipython")
    (setenv "PYTHONPATH" "~/util/Python27"))

;; Lisp Path
(if unixp
    (setq inferior-lisp-program "/usr/bin/clisp")
    (setq inferior-lisp-program "~/util/clisp-2.49/clisp"))

;; hangul 3bulsik
(setq default-korean-keyboard "3")

;; Korean font
(set-fontset-font "fontset-default" '(#x1100 . #xffdc)
                  '("나눔고딕코딩" . "unicode-bmp"))

;; Korean letter setting
(when (and enable-multibyte-characters win32p)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)
  (prefer-coding-system 'utf-8)
  (set-file-name-coding-system 'euc-kr))

;; global-hl-line
(global-hl-line-mode t)

;; y-or-n instead of yes-or-no
(fset 'yes-or-no-p 'y-or-n-p)

(use-package conf-general)
(use-package conf-dev)


(provide 'conf-init)
