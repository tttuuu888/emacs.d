;; Helm Setting

(define-key global-map (kbd "C-c i") 'helm-imenu)
(define-key global-map (kbd "C-c o") 'helm-git-files)   ;Open file
(define-key global-map (kbd "C-c p") 'helm-git-grep-at-point) ;greP