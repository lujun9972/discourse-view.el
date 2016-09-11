(require 'discourse-view-topic)

(defvar discourse-view-category-buffer "*discourse-view-category-buffer*")

(define-button-type 'discourse-view-category-button
  'action (lambda (b) (discourse-view-topic (button-get b 'id)))
  'follow-link t)

(defun discourse-view-category (category)
  (let ((topics (discourse-category-topics discourse-view-api category)))
    (select-window (display-buffer (get-buffer-create discourse-view-category-buffer)))
    (erase-buffer)
    (mapc (lambda (topic)
            (let ((id (discourse-get-id topic))
                  (title (discourse--extract-response-data topic '(title)))
                  (excerpt (discourse--extract-response-data topic '(excerpt))))
              (insert-text-button title
                                  :type 'discourse-view-category-button
                                  'id id
                                  'help-echo excerpt))
            (newline))
          topics)
    (org-mode)))


;; (discourse-view-category 5)

(provide 'discourse-view-category)
