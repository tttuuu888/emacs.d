;; Auto-complete + Yasnippet setting

(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d//ac-dict")
(ac-config-default)

(require 'yasnippet)
(define-key yas-minor-mode-map (kbd "<backtab>") 'yas-expand)
