(defun ome-ruby-mode-setup ()
  ;; Ah, this huge auto-mode-alist list comes from emacs prelude
  (add-to-list 'auto-mode-alist '("\\.rake\\'" . ruby-mode))
  (add-to-list 'auto-mode-alist '("Rakefile\\'" . ruby-mode))
  (add-to-list 'auto-mode-alist '("\\.gemspec\\'" . ruby-mode))
  (add-to-list 'auto-mode-alist '("\\.ru\\'" . ruby-mode))
  (add-to-list 'auto-mode-alist '("Gemfile\\'" . ruby-mode))
  (add-to-list 'auto-mode-alist '("Guardfile\\'" . ruby-mode))
  (add-to-list 'auto-mode-alist '("Capfile\\'" . ruby-mode))
  (add-to-list 'auto-mode-alist '("\\.thor\\'" . ruby-mode))
  (add-to-list 'auto-mode-alist '("Thorfile\\'" . ruby-mode))
  (add-to-list 'auto-mode-alist '("Vagrantfile\\'" . ruby-mode))
  (add-to-list 'auto-mode-alist '("\\.jbuilder\\'" . ruby-mode))
  (add-hook 'ruby-mode-hook
            (lambda ()
              (indent-guide-mode 1))))

(ome-ruby-mode-setup)

(defun ome-inf-ruby-setup ()
  (require 'inf-ruby)
  (define-key inf-ruby-minor-mode-map (kbd "C-c C-z") 'run-ruby)
  (when (executable-find "pry")
    (add-to-list 'inf-ruby-implementations '("pry" . "pry"))
    (setq inf-ruby-default-implementation "pry")))

(ome-install 'inf-ruby)

(defun ome-robe-mode-setup ()
  (add-hook 'robe-mode-hook 'ac-robe-setup)
  (add-to-list 'ac-modes 'inf-ruby-mode)
  (add-hook 'inf-ruby-mode-hook 'ac-robe-setup))

(ome-install 'robe-mode)

(when (require 'smartparens nil 'noerror)
  (require 'smartparens-ruby))

(defun ome-rbenv-setup ()
  ;; when user installed rbenv via homebrew on Mac OS X
  (when (and (memq window-system '(mac ns))
             (file-exists-p "/usr/local/opt/rbenv"))
    (setq rbenv-installation-dir "/usr/local/opt/rbenv"))
  (require 'rbenv)
  (global-rbenv-mode t))

(when (file-exists-p "~/.rbenv/version")
  (ome-install 'rbenv))

(defun ome-yard-mode-setup ()
  (add-hook 'ruby-mode-hook 'yard-mode)
  (add-hook 'ruby-mode-hook 'eldoc-mode))

(ome-install 'yard-mode)
