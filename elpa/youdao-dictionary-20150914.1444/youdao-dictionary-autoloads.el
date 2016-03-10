;;; youdao-dictionary-autoloads.el --- automatically extracted autoloads
;;
;;; Code:
(add-to-list 'load-path (or (file-name-directory #$) (car load-path)))

;;;### (autoloads nil "youdao-dictionary" "youdao-dictionary.el"
;;;;;;  (22177 40294 229150 925000))
;;; Generated autoloads from youdao-dictionary.el

(define-namespace youdao-dictionary- (defconst api-url "http://fanyi.youdao.com/openapi.do?keyfrom=YouDaoCV&key=659600698&type=data&doctype=json&version=1.1&q=%s" "Youdao dictionary API template, URL `http://dict.youdao.com/'.") (defconst voice-url "http://dict.youdao.com/dictvoice?type=2&audio=%s" "Youdao dictionary API for query the voice of word.") (defcustom buffer-name "*Youdao Dictionary*" "Result Buffer name." :type 'string) (defcustom search-history-file nil "If non-nil, the file be used for saving searching history." :type '(choice (const :tag "Don't save history" nil) (string :tag "File path"))) (defcustom use-chinese-word-segmentation nil "If Non-nil, support Chinese word segmentation(中文分词).\n\nSee URL `https://github.com/xuchunyang/chinese-word-at-point.el' for more info." :type 'boolean) (defun -format-voice-url (query-word) "Format QUERY-WORD as voice url." (format voice-url (url-hexify-string query-word))) (defun -format-request-url (query-word) "Format QUERY-WORD as a HTTP request URL." (format api-url (url-hexify-string query-word))) (defun -request (word) "Request WORD, return JSON as an alist if successes." (when (and search-history-file (file-writable-p search-history-file)) (append-to-file (concat word "\n") nil search-history-file)) (let (json) (with-current-buffer (url-retrieve-synchronously (-format-request-url word)) (set-buffer-multibyte t) (goto-char (point-min)) (when (not (string-match "200 OK" (buffer-string))) (error "Problem connecting to the server")) (re-search-forward "^$" nil 'move) (setq json (json-read-from-string (buffer-substring-no-properties (point) (point-max)))) (kill-buffer (current-buffer))) json)) (defun -explains (json) "Return explains as a vector extracted from JSON." (cdr (assoc 'explains (cdr (assoc 'basic json))))) (defun -prompt-input nil "Prompt input object for translate." (let ((current-word (-region-or-word))) (read-string (format "Word (%s): " (or current-word "")) nil nil current-word))) (defun -strip-explain (explain) "Remove unneed info in EXPLAIN for replace.\n\ni.e. `[语][计] dictionary' => 'dictionary'." (replace-regexp-in-string "^[[].* " "" explain)) (defun -region-or-word nil "Return word in region or word at point." (if (use-region-p) (buffer-substring-no-properties (region-beginning) (region-end)) (thing-at-point (if use-chinese-word-segmentation 'chinese-or-other-word 'word) t))) (defun -format-result (word) "Format request result of WORD." (let* ((json (-request word)) (query (assoc-default 'query json)) (translation (assoc-default 'translation json)) (errorCode (assoc-default 'errorCode json)) (web (assoc-default 'web json)) (basic (assoc-default 'basic json)) (phonetic (assoc-default 'phonetic basic)) (translation-str (mapconcat (lambda (trans) (concat "- " trans)) translation "\n")) (basic-explains-str (mapconcat (lambda (explain) (concat "- " explain)) (assoc-default 'explains basic) "\n")) (web-str (mapconcat (lambda (k-v) (format "- %s :: %s" (assoc-default 'key k-v) (mapconcat 'identity (assoc-default 'value k-v) "; "))) web "\n"))) (if basic (format "%s [%s]\n\n* Basic Explains\n%s\n\n* Web References\n%s\n" query phonetic basic-explains-str web-str) (format "%s\n\n* Translation\n%s\n" query translation-str)))) (defun -search-and-show-in-buffer (word) "Search WORD and show result in `youdao-dictionary-buffer-name' buffer." (if word (with-current-buffer (get-buffer-create buffer-name) (setq buffer-read-only nil) (erase-buffer) (org-mode) (insert (-format-result word)) (goto-char (point-min)) (setq buffer-read-only t) (use-local-map (copy-keymap org-mode-map)) (local-set-key "q" 'quit-window) (set (make-local-variable 'current-buffer-word) word) (local-set-key "p" (lambda nil (interactive) (if (local-variable-if-set-p 'current-buffer-word) (-play-voice current-buffer-word)))) (local-set-key "y" 'youdao-dictionary-play-voice-at-point) (switch-to-buffer-other-window buffer-name)) (message "Nothing to look up"))) :autoload (defun search-at-point nil "Search word at point and display result with buffer." (interactive) (let ((word (-region-or-word))) (-search-and-show-in-buffer word))) :autoload (defun search-at-point+ nil "Search word at point and display result with popup-tip." (interactive) (let ((word (-region-or-word))) (if word (popup-tip (-format-result word)) (message "Nothing to look up")))) :autoload (defun search-from-input nil "Search word from input and display result with buffer." (interactive) (let ((word (-prompt-input))) (-search-and-show-in-buffer word))) :autoload (defun search-and-replace nil "Search word at point and replace this word with popup menu." (interactive) (if (use-region-p) (let ((region-beginning (region-beginning)) (region-end (region-end)) (selected (popup-menu* (mapcar #'-strip-explain (append (-explains (-request (-region-or-word))) nil))))) (when selected (insert selected) (kill-region region-beginning region-end))) (let* ((bounds (bounds-of-thing-at-point (if use-chinese-word-segmentation 'chinese-or-other-word 'word))) (beginning-of-word (car bounds)) (end-of-word (cdr bounds))) (when bounds (let ((selected (popup-menu* (mapcar #'-strip-explain (append (-explains (-request (thing-at-point (if use-chinese-word-segmentation 'chinese-or-other-word 'word)))) nil))))) (when selected (insert selected) (kill-region beginning-of-word end-of-word))))))) (defvar history nil) :autoload (defun search (query) "Show the explanation of QUERY from Youdao dictionary." (interactive (let* ((string (or (if (use-region-p) (buffer-substring (region-beginning) (region-end)) (thing-at-point 'word)) (read-string "Search Youdao Dictionary: " nil 'youdao-dictionary-history)))) (list string))) (-search-and-show-in-buffer query)) (defun -play-voice (word) "Play voice of the WORD if there has mplayer or mpg123 program." (let ((player (or (executable-find "mplayer") (executable-find "mpg123")))) (if player (start-process player nil player (-format-voice-url word)) (user-error "mplayer or mpg123 is needed to play word voice")))) :autoload (defun play-voice-at-point nil "Play voice of the word at point." (interactive) (let ((word (-region-or-word))) (-play-voice word))) :autoload (defun play-voice-from-input nil "Play voice of user input word." (interactive) (let ((word (-prompt-input))) (-play-voice word))))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; End:
;;; youdao-dictionary-autoloads.el ends here