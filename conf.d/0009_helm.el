;; Helm Setting

(global-set-key (kbd "M-y") 'helm-show-kill-ring)

(define-key global-map (kbd "C-c i") 'helm-semantic-or-imenu)
(define-key global-map (kbd "C-c o") 'helm-git-files)   ;Open file
(define-key global-map (kbd "C-c p") 'helm-git-grep-at-point) ;greP

(add-hook 'eshell-mode-hook
          (lambda ()
              (define-key eshell-mode-map (kbd "C-c C-l")  'helm-eshell-history)))
