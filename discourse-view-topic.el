(defvar discourse-view-topic-buffer "*discourse-view-topic-buffer*")

(defun discourse-view-topic--html2text (html)
  (let ((html (with-temp-buffer
                (insert html)
                (libxml-parse-html-region (point-min) (point-max)))))
    (with-temp-buffer
      (shr-insert-document html)
      (buffer-string))))

(defun discourse-view-topic (topic)
  (let* ((topic (discourse-topic discourse-view-api topic))
         (title (discourse--extract-response-data topic '(title)))
         (posts (discourse--extract-response-data topic '(post_stream posts)))
         (suggested_topics (discourse--extract-response-data topic '(details suggested_topics))))
    (select-window (display-buffer (get-buffer-create discourse-view-topic-buffer)))
    (erase-buffer)
    (mapc (lambda (post)
            (let ((username (discourse--extract-response-data post '(username)))
                  (cooked (discourse-view-topic--html2text (discourse--extract-response-data post '(cooked)))))
              (insert "* " username "\n")
              ;; (insert "#+BEGIN_QUOTE \n")
              (insert cooked)
              ;; (insert "#+END_QUOTE")
              (newline)))
          posts)
    ;; (org-mode)
    ;; (org-show-block-all)
    ))

;; (discourse-view-topic 1137)

(provide 'discourse-view-topic)
