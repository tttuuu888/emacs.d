(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(c-basic-offset 4)
 '(c-default-style "k&r")
 '(completion-styles (quote (basic partial-completion emacs22 initials)))
 '(cua-enable-cua-keys nil)
 '(cua-mode t nil (cua-base))
 '(default-frame-alist (quote ((menu-bar-lines . 0) (tool-bar-lines . 0) (line-spacing . 2))))
 '(display-time-mode t)
 '(dynamic-completion-mode t)
 '(ediff-split-window-function (quote split-window-horizontally))
 '(gdb-many-windows t)
 '(global-auto-complete-mode t)
 '(global-auto-revert-mode t)
 '(global-semantic-stickyfunc-mode t)
 '(gud-gdb-command-name "gdb -i=mi")
 '(ibuffer-default-sorting-mode (quote major-mode))
 '(ibuffer-expert t t)
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(init-loader-show-log-after-init nil)
 '(iswitchb-mode t)
 '(large-file-warning-threshold nil)
 '(menu-bar-mode nil)
 '(org-babel-load-languages (quote ((emacs-lisp . t) (calc . t))))
 '(org-export-creator-info nil)
 '(org-export-default-language "kr")
 '(org-export-email-info t)
 '(org-export-headline-levels 2)
 '(org-export-html-footnotes-section "<div id=\"footnotes\">
<hr>
<h3 class=\"footnotes\">%s: </h3>
<div id=\"text-footnotes\">
%s
<hr>
</div>
</div>")
 '(org-export-html-validation-link "")
 '(org-export-section-number-format (quote ((("1" ".")) . "")))
 '(org-log-done (quote time) t)
 '(org-startup-indented t)
 '(recentf-mode t)
 '(safe-local-variable-values (quote ((dired-omit-mode . t))))
 '(scroll-bar-mode nil)
 '(semantic-mode t)
 '(send-mail-function (quote smtpmail-send-it))
 '(setq send-mail-function t)
 '(show-paren-mode t)
 '(size-indication-mode t)
 '(split-width-threshold 140)
 '(tab-always-indent (quote complete))
 '(tab-stop-list (quote (4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80 84 88 92 96 100)))
 '(tab-width 4)
 '(text-mode-hook (quote (text-mode-hook-identify)))
 '(tool-bar-mode nil)
 '(transient-mark-mode t)
 '(uniquify-buffer-name-style (quote forward) nil (uniquify))
 '(user-full-name "SeungKi Kim")
 '(user-mail-address "tttuuu888@gmail.com"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(diff-file-header ((t (:foreground "blue"))))
 '(diff-hunk-header ((t (:background "white" :foreground "blue"))))
 '(diff-index ((t (:foreground "light blue"))))
 '(diff-nonexistent ((t (:background "red"))))
 '(fixed-pitch ((default nil) (nil nil)))
 '(ggtags-highlight ((t nil)))
 '(helm-selection ((t (:background "red" :underline t))))
 '(magit-diff-add ((t (:foreground "magenta"))))
 '(region ((t (:background "yellow"))))
 '(sr-active-path-face ((t (:foreground "yellow" :height 120))))
 '(sr-directory-face ((t (:foreground "DeepSkyBlue"))))
 '(sr-highlight-path-face ((t (:background "yellow" :foreground "black" :height 120))))
 '(sr-passive-path-face ((t (:foreground "lightgray" :height 120))))
 '(sr-symlink-directory-face ((t (:foreground "brown" :slant normal))))
 '(sr-symlink-face ((t (:foreground "SkyBlue" :slant normal)))))
