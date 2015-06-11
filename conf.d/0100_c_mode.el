;; C-mode Setting

(use-package stickyfunc-enhance
    :mode "c-mode" "c++-mode")

(use-package ggtags
    :commands ggtags-mode
    :init
    (dolist (hook '(c-mode-hook c++-mode-hook java-mode-hook asm-mode-hook))
      (add-hook hook #'ggtags-mode)))

(use-package xcscope
    :commands cscope-minor-mode
    :init
    (dolist (hook '(c-mode-hook c++-mode-hook java-mode-hook asm-mode-hook))
      (add-hook hook #'cscope-minor-mode)))

;; #if 0 distinguish
(defun cpp-highlight-if-0/1 ()
  "Modify the face of text in between #if 0 ... #endif."
  (interactive)
  (setq cpp-known-face '(foreground-color . "red"))
  (setq cpp-unknown-face 'default)
  (setq cpp-face-type 'dark)
  (setq cpp-known-writable 't)
  (setq cpp-unknown-writable 't)
  (setq cpp-edit-list
        '((#("1" 0 1
             (fontified nil))
           nil
           (foreground-color . "gray")
           both nil)
          (#("0" 0 1
             (fontified nil))
           (foreground-color . "gray")
           nil
           both nil)))
  (cpp-highlight-buffer t))

(defun jpk/c-mode-hook ()
  (cpp-highlight-if-0/1)
  (add-hook 'after-save-hook 'cpp-highlight-if-0/1 'append 'local)
  )

;(add-hook 'c-mode-common-hook 'jpk/c-mode-hook)

;; #if 0 ~ #endif insert for the area
(defun izero-insert (start end)
  "Intesrt #if 0 at the beginning of region and #endif at the end of region"
  (interactive "r")
  (save-excursion
    (goto-char end) (end-of-line) (insert "\n#endif")
    (goto-char start) (beginning-of-line) (insert "#if 0\n"))
)

(add-to-list 'auto-mode-alist '("Makefile\\..*" . makefile-gmake-mode))
