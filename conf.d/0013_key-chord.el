;; Key-chord Setting

(require 'key-chord)
(key-chord-mode 1)

(key-chord-define-global " g" 'goto-line)
(key-chord-define-global " x" 'eshell)

(key-chord-define-global " i" 'previous-multiframe-window)
(key-chord-define-global " o" 'next-multiframe-window)

(key-chord-define-global " l" 'ibuffer)
(key-chord-define-global " b" 'ido-switch-buffer)

(key-chord-define-global " e" 'er/expand-region)
