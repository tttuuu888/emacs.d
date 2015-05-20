;; Clojure Setting

(add-hook 'clojure-mode-hook
 (lambda ()
   (define-key clojure-mode-map (kbd "TAB") 'cider-repl-indent-and-complete-symbol)
   (define-key clojure-mode-map (kbd "\r") 'newline-and-indent)))


(add-hook 'cider-repl-mode-hook
          (lambda ()
            (auto-complete-mode t)
            (ac-cider-setup)))

; Paredit
(add-hook 'clojure-mode-hook 'enable-paredit-mode)
