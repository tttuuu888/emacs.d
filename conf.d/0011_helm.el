;; Helm Setting

;; anything-git-grep replaces helm-git-grep in Windows (helm-git-grep often stops in Windows)
(when win32p (require 'anything-git-grep))

(define-key global-map [(control c)(h)(f)] 'helm-git-files)
(if unixp
     (define-key global-map [(control c)(h)(s)] 'helm-git-grep-at-point)
     (define-key global-map [(control c)(h)(s)] 'anything-git-grep-from-here))
