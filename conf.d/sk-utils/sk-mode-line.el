;;; sk-mode-line.el --- Simple modeline setting.

;; Copyright (C) 2017-2018 SeungKi Kim

;; Author: SeungKi Kim <tttuuu888@gmail.com>
;; URL: https://github.com/tttuuu888/.emacs.d
;; Version: 0.3.0

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
                      :foreground "Gray2"
                      :background "Darkseagreen"
                      :overline (face-background 'default)
                      :box nil)
  (set-face-attribute 'mode-line-inactive nil
                      :foreground "Gray55"
                      :background (face-background 'default)
                      :overline (face-background 'default)
                      :box nil)
  (setq-default
   mode-line-format
   '("%e"
     (:eval
      (let* ((seperator "｜") ;; seperator - fullwidth vertical line
             (evil-info (if (and (featurep 'evil) evil-mode)
                            (concat " " (upcase (symbol-name evil-state)))
                          ""))
             (buffer-info (concat " %* %I " current-input-method-title))
             (buffer-name (propertize " %b " 'face 'mode-line-emphasis))
             (vc-info (if vc-mode
                          (concat seperator
                                  (format-mode-line '(vc-mode vc-mode))
                                  " ")
                        ""))
             (mode-info (propertize
                         (concat " " (format-mode-line mode-name) " ")
                         'face 'mode-line-inactive))
             (line-info (format-mode-line " %l :%3c "))
             (pos-info (format-mode-line " %p%%  "))
             (right-info (concat line-info seperator pos-info))
             (right-length (length right-info))
             (center-fill (propertize
                           " "
                           'face 'mode-line-inactive
                           'display
                           `((space :align-to
                                    (- (+ right right-fringe right-margin)
                                       ,right-length))))))
        (concat
         evil-info
         buffer-info
         buffer-name
         vc-info
         mode-info
         center-fill
         right-info))))))


(provide 'sk-mode-line)

;;; sk-mode-line.el ends here
