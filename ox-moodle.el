;;; ox-moodle.el --- Summary
;;; Export an org mode document to a simplified html format suitable for
;;; copying into a moodle feedback slot.
;;;
;;; No overall document structure is added to the html. The org is relatively
;;; unchanged.  Level one headings are underlined, level 2 are bold, and level 3
;;; are italic, deeper headings are unformatted, by default. This can be changed
;;; by setting the value of the alist "ox-moodle-headline-format-alist".
;;;
;;; Commentary:
;;;

;;; Code:
(require 'ox-html)

(defgroup ox-moodle-settings nil
  "Org-mode export settings for moodle backend"
  :group 'org-export)

(defcustom ox-moodle-headline-format-alist
  '((1 . "u")
    (2 . "b")
    (3 . "i"))
  "Dictionary definig tags for formatting headlines to HTML."
  :group 'ox-moodle-settings
  :type 'alist)

(defun moodle-inner-template (contents info)
  "Return document body after HTML conversion.  CONTENTS is the
transcoded contents string.  INFO is a plist holding export
option"
  (contents))

(defun moodle-section (section contents info)
  "Return SECTION..."
  (concat "<br>\n" contents))

(defun moodle-template (contents info)
  "Return complete document string after HTML conversion.
CONTENTS is the transcoded contents string.  INFO is a plist
holding export options."
  (let ((title (plist-get info :title)))
    (format "<h1>%s</h1>\n%s" (org-export-data title info) contents)))


(defun org-moodle-headline (headline contents info)
  "Transcode a HEADLINE element from Org to HTML.
CONTENTS holds the contents of the headline.  INFO is a plist
holding contextual information."
  (let* ((level (org-export-get-relative-level headline info))
	 ;; TODO: make level non-relative
	 (text (org-export-data (org-element-property :title headline) info))
					;(tag (assoc level ox-moodle-headline-format-alist)))
	 (tag (cond ((= level 1) "u")
		    ((= level 2) "b")
		    ((= level 3) "i")
		    (else "p"))) ;; TODO fix headline assoc list?
    (format "<%s>%s</%s><br>\n%s" tag text tag (or contents "")))))


(org-export-define-derived-backend 'moodle 'html
  :menu-entry '(?m "moodle" (lambda (a s v b) (org-moodle-export-as-moodle a s v)))
  :translate-alist '((inner-template . plain2)
                     (template . moodle-template)
		     (section . moodle-section)
		     (headline . org-moodle-headline)))

(defun org-moodle-export-as-moodle (&optional async subtreep visible-only)
  "  "
  (interactive)
  (org-export-to-buffer 'moodle "*Org Moodle Export*"
    async subtreep visible-only nil nil (lambda () (html-mode))))





(provide 'ox-moodle)
;;; ox-moodle.el ends here
