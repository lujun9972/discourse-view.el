(require 'discourse)
(require 'discourse-view-category)
(require 'discourse-view-topic)

(defvar discourse-view-api nil
  "")

(defvar discourse-view-url  "https://emacs-china.org")

(defvar discourse-view-buffer "*discourse-view-buffer*")

(define-button-type 'discourse-view-button
  'action (lambda (b) (discourse-view-category (button-get b 'id)))
  'follow-link t)

(defun discourse-view ()
  (interactive)
  (setq discourse-view-api (make-discourse-api :url discourse-view-url))
  (let ((categories (discourse-categories discourse-view-api)))
    (select-window (display-buffer (get-buffer-create discourse-view-buffer)))
    (erase-buffer)
    (mapc (lambda (category)
            (let ((id (discourse-get-id category))
                  (name (discourse--extract-response-data category '(name)))
                  (description (discourse--extract-response-data category '(description))))
              (insert-text-button name
                                  :type 'discourse-view-button
                                  'id id
                                  'help-echo description))
            (newline))
          categories)))

(provide 'discourse-view)
