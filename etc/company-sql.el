;;; company-sql.el --- Company mode backend for sql-mode -*- lexical-binding: t -*-

;; Copyright (C) 2018 SeungKi Kim

;; Author: SeungKi Kim <tttuuu888@gmail.com>
;; URL: https://github.com/tttuuu888/.emacs.d
;; Version: 0.2.0
;; Package-Requires: ((company "0.8.0"))

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

(require 'company)

(eval-when-compile
  (require 'cl))

(defconst sql-completions
  '("ADD" "ALTER" "ANALYZE" "ASC" "BIGINT" "BLOB" "BY" "CACHE" "CHANGE"
    "CHAR" "CHARACTER" "CHECK" "CHECKSUM" "CLOSE" "COLLATION" "COLUMNS"
    "COMMIT" "CONVERT" "COUNT" "CREATE" "DATA" "DATABASE" "DATABASES"
    "DATE" "DEFAULT" "DELETE" "DESC" "DESCRIBE" "DISABLE" "DISCARD"
    "DISTINCT" "DO" "DOUBLE" "DROP" "DUMPFILE" "DUPLICATE" "ENABLE"
    "ENCLOSED" "ENGINES" "ENUM" "ERRORS" "ESCAPE" "EXISTS" "FIELDS"
    "FIRST" "FLOAT" "FLUSH" "FOREIGN" "FROM" "GRANT" "GRANTS" "GROUP"
    "HANDLER" "HAVING" "IF" "IGNORE" "IMPORT" "INDEX" "INFILE" "INNODB"
    "INSERT" "INT" "INTEGER" "INTO" "JOIN" "KEY" "KILL" "LAST" "LIKE"
    "LIMIT" "LINES" "LOAD" "LOCAL" "LOCK" "LOGS" "LONGBLOB" "LONGTEXT"
    "MEDIUMBLOB" "MEDIUMINT" "MEDIUMTEXT" "MODIFY" "NEXT" "NOT" "NULL"
    "NUMERIC" "ON" "OPEN" "OPTIMIZE" "ORDER" "OUTFILE" "PASSWORD" "PREV"
    "PRIMARY" "PRIVILEGES" "PROCEDURE" "READ" "REAL" "REFERENCES" "RENAME"
    "REPAIR" "REPLACE" "REQUIRE" "RESET" "RESTORE" "REVOKE" "ROLLBACK"
    "SAVEPOINT" "SELECT" "SET" "SHOW" "SLAVE" "SMALLINT" "START"
    "STARTING" "STATUS" "STOP" "TABLE" "TABLES" "TEMPORARY" "TERMINATED"
    "TEXT" "TIME" "TIMESTAMP" "TINYBLOB" "TINYINT" "TINYTEXT" "TO"
    "TRANSACTION" "TRUNCATE" "UNION" "UNIQUE" "UPDATE" "USE" "VALUES"
    "VARCHAR" "VARIABLES" "WARNINGS" "WHERE" "WITH"))

;;;###autoload
(defun company-sql (command &optional arg &rest ignored)
  (interactive (list 'interactive))
  (case command
    (interactive (company-begin-backend 'company-sql))
    (prefix (and (or (eq major-mode 'sql-interactive-mode)
                     (eq major-mode 'sql-mode))
                 (not (company-in-string-or-comment))
                 (let ((stab  (copy-syntax-table)))
                   (with-syntax-table stab
                     (modify-syntax-entry ?. "_")
                     (not (string-prefix-p "." (thing-at-point 'symbol)))))
                 (company-grab-symbol)))
    (candidates
    (cl-remove-if-not
      (lambda (c) (string-prefix-p arg c t))
      sql-completions))))

(provide 'company-sql)
;;; company-sql.el ends here
