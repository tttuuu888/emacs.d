;; Helm Setting

(global-set-key (kbd "C-c y") 'helm-show-kill-ring)

(define-key global-map (kbd "C-c i") 'helm-semantic-or-imenu)
(define-key global-map (kbd "C-c o") 'helm-git-files)   ;Open file
(define-key global-map (kbd "C-c p") 'helm-git-grep-at-point) ;greP

;; Projectile is only used for the directory not controlled by git.
(use-package helm-projectile
    :bind (("C-c h o" . helm-projectile-find-file)
           ("C-c h p" . helm-projectile-ag))
    :config
    (setq projectile-require-project-root nil))


(add-hook 'eshell-mode-hook
          (lambda ()
            (define-key eshell-mode-map (kbd "C-c C-l")  'helm-eshell-history)))
