;; Initial settings

(defconst win32p  (eq system-type 'windows-nt) "T if Windows system")
(defconst unixp   (eq system-type (or 'gnu/linux 'gnu/kfreebsd)) "T if Linux system")

;; Total Paths
(when unixp
    (setq-default exec-path
                  '(
                    "/usr/local/sbin"
                    "/usr/local/bin"
                    "/usr/sbin"
                    "/usr/bin"
                    "/sbin"
                    "/bin"
                    "~/Android/sdk/tools"
                    "~/Android/sdk/platform-tools"
                    "~/Android/android-ndk-r10d"
                    "~/Android/android-ndk-r10d/toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86_64/bin"
                    "~/prj/toolchain/bin"
                    "~/prj/toolchain/launchpad-gcc-arm/bin"
                    "~/prj/toolchain/mingw-w64-sysroot/bin"))
    (setenv "PATH" (mapconcat 'identity exec-path path-separator))
    (setq-default eshell-path-env (mapconcat 'identity exec-path path-separator)))

;; Set 'HOME' environment variable in Windows.

;; Python Path
(if unixp
    (setenv "PYTHONPATH" "/usr/local/bin/ipython")
    (setenv "PYTHONPATH" "~/util/Python27"))

;; Lisp Path
(if unixp
    (setq inferior-lisp-program "/usr/bin/clisp")
    ;;(setq inferior-lisp-program "/usr/bin/sbcl")
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

;;  M-up, M-down, M-left, and M-right keys.
(windmove-default-keybindings 'meta)

(use-package conf-general)
(use-package conf-dev)


(provide 'conf-init)
