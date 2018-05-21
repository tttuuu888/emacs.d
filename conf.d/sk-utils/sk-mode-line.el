;;; sk-mode-line.el --- Simple modeline setting.

;; Copyright (C) 2017 SeungKi Kim

;; Author: SeungKi Kim <tttuuu888@gmail.com>
;; URL: https://github.com/tttuuu888/.emacs.d
;; Version: 0.2.0

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Code:

(defun sk-mode-line ()
  (set-face-attribute 'mode-line nil
                      :foreground "black"
                      :background "gray"
                      :overline "dark gray"
                      :box (list :color "dark gray" :line-width -1))
  (set-face-attribute 'mode-line-inactive nil
                      :foreground "grey55"
                      :background "black"
                      :overline "dark gray"
                      :box (list :color "dark gray" :line-width -1))
  (setq-default
   mode-line-format
   '("%e"
     (:eval
      (let* ((seperator "｜")   ;; seperator - fullwidth vertical line
             (evil-info
              (if evil-mode
                  (concat "["
                          (upcase (substring (symbol-name evil-state) 0 1))
                          "]")
                ""))
             (buffer-info (concat " %* %I " current-input-method-title "%z: "))
             (buffer-name (propertize " %b " 'face 'bold))
             (mode-info (concat " " (format-mode-line mode-name) " "))
             (vc-info (format-mode-line '(vc-mode vc-mode)))
             (line-info (format-mode-line "%4l :%3c "))
             (pos-info (format-mode-line " %p%%"))
             (right-info (concat line-info seperator pos-info))
             (right-length (length right-info))
             (center-fill (propertize
                           " "
                           'display
                           `((space :align-to
                                    (- (+ right right-fringe right-margin)
                                       (+ ,right-length 2)))))))
        (concat
         evil-info
         buffer-info
         buffer-name
         seperator
         mode-info
         seperator
         vc-info
         center-fill
         right-info))))))


(provide 'sk-mode-line)

;;; sk-mode-line.el ends here
