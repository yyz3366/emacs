(defun ome-go-mode-setup ()

  ; set the GOPATH here if not already
  ; (setenv "GOPATH" "/home/chuchao/gowork")

  ;; enable the go-mode
  (require 'go-mode)
  (add-hook 'before-save-hook 'gofmt-before-save)
  
  ; key binding for go-remove-unused-imports
  (add-hook 'go-mode-hook '(lambda ()
    (local-set-key (kbd "C-c C-r") 'go-remove-unused-imports)))

  ; key binding for go-goto-imports
  (add-hook 'go-mode-hook '(lambda ()
    (local-set-key (kbd "C-c C-g") 'go-goto-imports)))
    
  ; bind C-c C-f for gofmt  
  (add-hook 'go-mode-hook '(lambda ()
    (local-set-key (kbd "C-c C-f") 'gofmt)))
  
  ; godoc
  (when (executable-find "godoc")
    (add-hook 'go-mode-hook '(lambda ()
      (local-set-key (kbd "C-c C-k") 'godoc))))

  ; goflymake
  (when (executable-find "goflymake")
    (add-to-list 'load-path (concat (getenv "GOPATH") "/src/github.com/dougm/goflymake"))
    (require 'go-flymake)
    (require 'go-flycheck))

  ; go-code
  (when (executable-find "gocode")
    
    (add-to-list 'load-path (concat (getenv "GOPATH") "/src/github.com/nsf/gocode/emacs-company"))
    (require 'company-go)

    (add-hook 'go-mode-hook 'company-mode)
    (add-hook 'go-mode-hook (lambda ()
      (set (make-local-variable 'company-backends) '(company-go))
      (company-mode)))))

(when (executable-find "go")
  (ome-install 'go-mode))
