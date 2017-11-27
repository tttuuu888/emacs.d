;;; sk-mode-line.el --- Simple modeline setting.

;; Copyright (C) 2017 SeungKi Kim

;; Author: SeungKi Kim <tttuuu888@gmail.com>
;; URL: https://github.com/tttuuu888/.emacs.d
;; Version: 0.1

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
                      :box (list :color "dark gray"))
  (set-face-attribute 'mode-line-inactive nil
                      :foreground "grey55"
                      :background "black"
                      :box (list :color "dark gray"))
  (setq-default
   mode-line-format
   '(
     " %* %I "
     (:propertize current-input-method-title)
     "%z:  "
     (:propertize "%b" face bold)
     (:propertize " ｜ ")
     (:propertize mode-name)
     (:propertize " ｜")
     (:propertize (vc-mode vc-mode))
     (:eval
      (let* ((line-info (format-mode-line (list (propertize " %4l :%3c"))))
             (seperator (format-mode-line (list (propertize " ｜ "))))
             (pos-info (format-mode-line (list (propertize "%p%%"))))
             (right-length (length (concat line-info seperator pos-info)))
             (center-fill (propertize
                           " "
                           'display
                           `((space :align-to
                                    (- (+ right right-fringe right-margin)
                                       (+ ,right-length 3)))))))
        (list
         center-fill
         line-info
         seperator
         pos-info))))))


(provide 'sk-mode-line)

;;; sk-mode-line.el ends here
