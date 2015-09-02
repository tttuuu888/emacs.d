;; My functions

;; build functions
(defun parent-directory (dir)
  (unless (equal "/" dir)
    (file-name-directory (directory-file-name dir))))

(defun find-file-in-tree (dir fname)
  (let ((file (concat dir fname))
        (parent (parent-directory dir)))
    (if (file-exists-p file)
        dir
        (when parent
          (find-file-in-tree parent fname)))))

(defun sk-make ()
  "Find a Makefile path and excute make"
  (interactive)
  (let ((dir (find-file-in-tree (file-name-directory default-directory) "Makefile")))
    (unless (equal dir nil)
      (compile (concat "make -j8 -C " dir)))))

(defun sk-clean ()
  "Find a Makefile path and excute make"
  (interactive)
  (let ((dir (find-file-in-tree (file-name-directory default-directory) "Makefile")))
    (unless (equal dir nil)
      (compile (concat "make -C " dir " clean")))))

(defun sk-rebuild ()
  "Find a Makefile path and excute rebuild(clean and make)"
  (interactive)
  (let ((dir (find-file-in-tree (file-name-directory default-directory) "Makefile")))
    (unless (equal dir nil)
      (call-process "make" nil nil nil "-C" dir "clean")
      (compile (concat "make -j8 -C " dir)))))


;; making .c .h files
(defun make-author-info (file-name)
  (concat "/**\n * " file-name "
 * Created by SK Kim\n * " (format-time-string "%Y-%m-%d") "
 */\n"))

(defun c-file-shape (file-name)
  (concat (make-author-info (concat file-name ".c"))
"/* Includes ------------------------------------------------------------------*/
/* Private define ------------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private functions ---------------------------------------------------------*/\n\n\n\n\n
/******************************** END OF FILE *********************************/"))

(defun c-header-shape (file-name)
  (concat (make-author-info (concat file-name ".h"))
"#ifndef " (upcase file-name) "_H_
#define " (upcase file-name) "_H_
/* Includes ------------------------------------------------------------------*/
/* Exported macros -----------------------------------------------------------*/
/* Exported types ------------------------------------------------------------*/
/* Exported constants --------------------------------------------------------*/
/* Exported functions ------------------------------------------------------- */\n\n\n\n\n
#endif  /* " (upcase file-name) "_H_ */
/******************************** END OF FILE *********************************/"))

(defun c-header-insert (file-name)
  (interactive "sEnter File name : ")
  (insert (c-header-shape file-name)))

(defun create-h-file (file-name)
  (interactive "sEnter File name : ")
  (append-to-file (c-header-shape file-name) nil (concat file-name ".h")))

(defun c-file-insert (file-name)
  (interactive "sEnter File name : ")
  (insert (c-file-shape file-name)))

(defun create-c-file (file-name)
  (interactive "sEnter File name : ")
  (append-to-file (c-file-shape file-name) nil (concat file-name ".c")))

(defun create-ch-file (file-name)
  (interactive "sEnter File name : ")
  (create-h-file file-name)
  (create-c-file file-name))

(defun sk-find-project-root (dir)
  (or (find-file-in-tree (file-name-directory dir) ".git")
      (find-file-in-tree (file-name-directory dir) "project.clj")
      (find-file-in-tree (file-name-directory dir) "Makefile")
      (find-file-in-tree (file-name-directory dir) "READEME")
      (find-file-in-tree (file-name-directory dir) "build.gradle")
      "./"))


(defun clang-complete-armcc ()
  (interactive)
  (let ((dir (find-file-in-tree (file-name-directory default-directory) "Makefile"))
        (ccpy "~/.emacs.d/conf.d/external/cc_args.py ")
        (armcc "arm-none-eabi-gcc")
        (armc++ "arm-none-eabi-g++"))
    (compile (concat "make -j8 -C " dir " 'CC=" ccpy armcc "' 'CXX=" ccpy armc++ "' -B"))))

(defun clang-complete-gcc ()
  (interactive)
  (let ((dir (find-file-in-tree (file-name-directory default-directory) "Makefile"))
        (ccpy "~/.emacs.d/conf.d/external/cc_args.py ")
        (armcc "gcc")
        (armc++ "g++"))
    (compile (concat "make -j8 -C " dir " 'CC=" ccpy armcc "' 'CXX=" ccpy armc++ "' -B"))))

(defun clang-complete-make ()
  (interactive)
  (let ((includes
         (mapcar (lambda (x) (concat "-I" x "\n"))
                 (split-string
                  (shell-command-to-string "find -name '*.h' -printf '%h\n' | sort -u")))))
    (if (file-exists-p "./.clang_complete")
        (message ".clang_complete already exists.")
        (progn
          (write-region "" nil "./.clang_complete")
          (mapc (lambda (x) (append-to-file x nil "./.clang_complete")) includes)))))



(provide 'sk-dev-utils)
