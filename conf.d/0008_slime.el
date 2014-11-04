;; Slime Setting

;; Set your lisp system and, optionally, some contribs
(setq slime-contribs '(slime-fancy))

;; Slime
(setq lisp-indent-function 'common-lisp-indent-function
      slime-complete-symbol-function 'slime-fuzzy-complete-symbol
      slime-startup-animation nil
      slime-enable-evaluate-in-emacs t
      slime-log-events t
      slime-outline-mode-in-events-buffer nil
      slime-repl-return-behaviour :send-only-if-after-complete
      slime-autodoc-use-multiline-p t
      slime-highlight-compiler-notes t)

(add-hook 'slime-mode-hook
 (lambda ()
  (define-key slime-mode-map (kbd "TAB") 'slime-indent-and-complete-symbol)
  (define-key slime-mode-map (kbd "\r") 'newline-and-indent)))

;; For developing utf-8 base Web page programing
;; --> Korean crash to 0009_utils.el
;(set-language-environment "UTF-8")
;(setq slime-net-coding-system 'utf-8-unix)
