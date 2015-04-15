;; Paths Setting

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
          "/usr/lib/emacs/24.3/x86_64-linux-gnu"
          "/home/sk/prj/Android/android-sdk-linux/tools"
          "/home/sk/prj/Android/android-sdk-linux/platform-tools"
          "/home/sk/prj/Android/android-ndk-r6/toolchains/arm-linux-androideabi-4.4.3/prebuilt/linux-x86/bin"
          "/home/sk/Android/android-ndk-r10d"
          "/home/sk/prj/toolchain/launchpad-gcc-arm/bin"
;          "/home/sk/prj/toolchain/CodeSourcery/Sourciry_G++-Lite/bin"
          "/home/sk/prj/toolchain/bin"))
  (setq-default exec-path  
        '(
          "C:/Program Files/ARM/bin/win_32-pentium"
          "C:/Program Files/ARM/RVCT/Programs/4.1/462/win_32-pentium"
          "C:/Program Files/ARM/RVI/Tools/4.0/90/programs/win_32-pentium"
          "C:/Program Files/ARM/Utilities/FLEXlm/10.8.5.0/1/win_32-pentium"
          "C:/Program Files/ARM/RVD/Core/4.1/54/win_32-pentium/bin"
          "D:/home/util/android/sdk/platform-tools"
          "D:/home/util/Python27"  
          "D:/home/util/Python27/Scripts"  
          "D:/home/util/Python27/Lib/site-packages/PyQt4"          
          "D:/home/util/cygwin/bin"
          "D:/home/.lein/bin")))


;; Shell PATH environment
(setenv "PATH" (mapconcat 'identity exec-path path-separator))
(setq-default eshell-path-env (mapconcat 'identity exec-path path-separator))

;;Python Path
(if unixp
    (setenv "PYTHONPATH" "/usr/bin/python")
    (setenv "PYTHONPATH" "D:/home/util/Python27"))

;; Lisp Path
(if unixp
    (setq inferior-lisp-program "/usr/bin/clisp")
    ;(setq inferior-lisp-program "/usr/bin/sbcl")
    (setq inferior-lisp-program "D:/home/util/clisp-2.49/clisp"))
