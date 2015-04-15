;; Clojure Setting

(add-hook 'clojure-mode-hook
 (lambda ()
  (define-key clojure-mode-map (kbd "TAB") 'cider-repl-indent-and-complete-symbol)
  (define-key clojure-mode-map (kbd "\r") 'newline-and-indent)))

; Paredit
(add-hook 'clojure-mode-hook 'enable-paredit-mode)
