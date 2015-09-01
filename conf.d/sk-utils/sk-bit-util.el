;; SK bit util

(defun is-bit-set (num nth-bit)
  (if (= 0 (logand num (lsh 1 nth-bit)))
      0
      1))

(defun get-num-lst (lst num end)
  (if (< num end)
      (get-num-lst (list (cons (/ num 10) (car lst)) (cons (% num 10) (car (cdr lst)))) (+ num 1) end)
      lst))

(defun get-needed-bits (num nbits)
  (if (not (zerop num))
      (get-needed-bits (lsh num -1) (+ nbits 1))
      nbits))

(defun get-needed-sections (num)
  (+ (/ (get-needed-bits num 0) 4) (if (= 0 (% (get-needed-bits num 0) 4)) 0 1)))

(defun get-bits-list (num)
  (get-num-lst '() 0 (* 4 (get-needed-sections num))))


(let ((value ""))
  (dolist (elt '(1 2 3 4 5) value)
    (setq value (concat "%d " value))))


(defun format-for-bits (num helper-lst)
  (let ((hvalue "")
        (lvalue "")
        (seperator "")
        (bit-value ""))
    (let ((count 0))
      (dolist (elt (car helper-lst) hvalue)
        (progn
          (setq hvalue (concat
                        (if (= 0 (nth count (reverse (car helper-lst))))
                            " "
                            (number-to-string (nth count (reverse (car helper-lst)))))
                        " "
                        (if (= 0 (% count 4)) " ")
                        hvalue))
          (setq count (+ 1 count)))))
    (let ((count 0))
      (dolist (elt (car (cdr helper-lst)) lvalue)
        (progn
          (setq lvalue (concat
                        (number-to-string (nth count (reverse (car (cdr helper-lst)))))
                        " "
                        (if (= 0 (% count 4)) " ")
                        lvalue))
          (setq count (+ 1 count)))))
    (let ((count 0))
      (dolist (elt (car helper-lst) seperator)
        (setq seperator (concat
                        "--"
                        (if (= 0 (% count 4)) " ")
                        seperator))
        (setq count (+ 1 count))))
    (let ((count 0))
      (dolist (elt (car helper-lst) bit-value)
        (setq bit-value (concat
                        (number-to-string (is-bit-set num count))
                        " "
                        (if (= 0 (% count 4)) " ")
                        bit-value))
        (setq count (+ 1 count))))
    (concat hvalue "\n " lvalue "\n " seperator "\n " bit-value)))

(defun print-num-bits (num)
  (let ((helper-lst (get-bits-list num)))
    (format-for-bits num helper-lst)))

(defun sk-bit-print (num)
  (progn (print (print-num-bits num)) nil))



(provide 'sk-bit-util)
