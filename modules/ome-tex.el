(defun ome-auctex-setup ()
  (when (require 'smartparens nil 'noerror)
    (require 'smartparens-latex))
  (setq TeX-auto-save t)                ; Automatically save style information
                                        ; when saving the buffer
  (setq TeX-parse-self t)               ; Parse file after loading it if no
                                        ; style hook is found for it.
  (setq LaTeX-syntactic-comment t)
  (setq TeX-auto-untabify t)            ; remove all tabs before saving
  (setq reftex-plug-into-AUCTeX t)
  (setq-default TeX-engine 'xetex)      ; use xelatex by default

  ;; Mac OS X fallback to the "open" program as the default viewer for all
  ;; types of files.
  (cond
   ;; settings for Linux
   ((eq system-type 'gnu/linux)
    (cond
     ((executable-find "okular")
      (setq TeX-view-program-selection
            '((output-pdf "Okular")
              (output-dvi "Okular"))))
     ((executable-find "evince")
      (setq TeX-view-program-selection
            '((output-pdf "Evince")
              (output-dvi "Evince"))))
     (t
      (setq TeX-view-program-selection
            '((output-pdf "xdg-open")
              (output-dvi "xdg-open")))))))

  (add-hook 'TeX-mode-hook
            (lambda ()
              (outline-minor-mode t)
              (flyspell-mode t)
              (TeX-interactive-mode t)
              (TeX-PDF-mode t)
              (TeX-fold-mode t)))

  (add-hook 'LaTeX-mode-hook
            (lambda ()
              (LaTeX-math-mode t)
              (reftex-mode t)))

  (add-hook 'reftex-toc-mode-hook
            (lambda ()
              (when (featurep 'evil)
                (turn-off-evil-mode)))))

(when (executable-find
       (if (eq system-type 'darwin)
           ;; MacTeX install all its executables to /usr/texbin directory
           "/usr/texbin/pdflatex"
         "pdflatex"))
  (ome-install 'auctex))

(defvar ome-LaTeX-shell-escape-mode nil
  "Whether or not LaTeX shell escape mode is enabled.")

(defun ome-LaTeX-toggle-shell-escape ()
  (interactive)
  (if ome-LaTeX-shell-escape-mode
      (progn
        (setcdr (assoc "LaTeX" TeX-command-list)
                '("%`%l%(mode)%' %t"
                  TeX-run-TeX nil (latex-mode doctex-mode) :help "Run LaTeX"))
        (setq ome-LaTeX-shell-escape-mode nil)
        (message "LaTeX shell escape mode turned off."))
    (progn
      (setcdr (assoc "LaTeX" TeX-command-list)
              '("%`%l%(mode) -shell-escape%' %t"
                TeX-run-TeX nil (latex-mode doctex-mode) :help "Run LaTeX")))
    (setq ome-LaTeX-shell-escape-mode t)
    (message "LaTeX shell escape mode turned on.")))

;; (define-key org-mode-map (kbd "C-c C-x x") 'ome-LaTeX-toggle-shell-escape)

(defun ome-cdlatex-mode-setup ()
  (add-hook 'LaTeX-mode-hook 'turn-on-cdlatex)
  (add-hook 'latex-mode-hook 'turn-on-cdlatex))

(when (el-get-package-is-installed 'auctex)
  (ome-install 'cdlatex-mode))
