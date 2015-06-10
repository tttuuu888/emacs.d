;; Key-chord Setting

(require 'key-chord)
(key-chord-mode 1)

(key-chord-define-global "xc" 'eshell)
(key-chord-define-global "op" 'other-window)
(key-chord-define-global "jk" 'ido-switch-buffer)
(key-chord-define-global "-=" 'er/expand-region)
