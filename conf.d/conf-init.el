;; Initial settings

(defconst win32p  (eq system-type 'windows-nt) "T if Windows system")
(defconst unixp   (eq system-type (or 'gnu/linux 'gnu/kfreebsd)) "T if Linux system")

;; Total Paths
(if unixp
    (setq-default exec-path
                  '(
                    "/usr/local/sbin"
                    "/usr/local/bin"
                    "/usr/sbin"
                    "/usr/bin"
                    "/sbin"
                    "/bin"
                    "/home/sk/prj/Android/android-sdk-linux/tools"
                    "/home/sk/prj/Android/android-sdk-linux/platform-tools"
                    "/home/sk/prj/Android/android-ndk-r6/toolchains/arm-linux-androideabi-4.4.3/prebuilt/linux-x86/bin"
                    "/home/sk/Android/android-ndk-r10d/toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86_64/bin"
                    "/home/sk/Android/android-ndk-r10d"
                    "/home/sk/prj/toolchain/launchpad-gcc-arm/bin"
                    "/home/sk/prj/toolchain/mingw-w64-sysroot/bin"
                    "/home/sk/prj/toolchain/bin"))
    (setq-default exec-path
                  '(
                    "C:/home/util/android/sdk/platform-tools"
                    "C:/home/util/Python27"
                    "C:/home/util/Python27/Scripts"
                    "C:/home/util/Python27/Lib/site-packages/PyQt4"
                    "C:/home/util/cygwin/bin"
                    "C:/home/util/Git/bin"
                    "C:/home/.lein/bin")))


;; Shell PATH environment
(setenv "PATH" (mapconcat 'identity exec-path path-separator))
(setq-default eshell-path-env (mapconcat 'identity exec-path path-separator))

;;Python Path
(if unixp
    (setenv "PYTHONPATH" "/usr/local/bin/ipython")
    (setenv "PYTHONPATH" "D:/home/util/Python27"))

;; Lisp Path
(if unixp
    (setq inferior-lisp-program "/usr/bin/clisp")
                                        ;(setq inferior-lisp-program "/usr/bin/sbcl")
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

(use-package conf-dev)
(use-package conf-etc)


(provide 'conf-init)
