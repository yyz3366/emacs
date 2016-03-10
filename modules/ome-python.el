(when (version< emacs-version "24.3")
  (ome-install 'python24))

(defun ome-elpy-setup ()
  (elpy-enable)
  (setq elpy-rpc-backend "jedi")
  (when (executable-find "ipython")
    (elpy-use-ipython))
  (setq elpy-modules '(elpy-module-sane-defaults
                       elpy-module-company
                       elpy-module-eldoc
                       elpy-module-highlight-indentation
                       elpy-module-pyvenv
                       elpy-module-yasnippet))
  (define-key python-mode-map (kbd "RET")
    'newline-and-indent)
  (add-hook 'python-mode-hook
            (lambda ()
              (set (make-local-variable 'comment-inline-offset) 2)
              (auto-complete-mode -1))))

(ome-install 'elpy)

(add-to-list 'auto-mode-alist '("\\.wsgi\\'" . python-mode))

(defun ome-pyenv-setup ()
  ;; when user installed pyenv via homebrew on Mac OS X
  (when (and (memq window-system '(mac ns))
             (file-exists-p "/usr/local/opt/pyenv"))
    (setq pyenv-installation-dir "/usr/local/opt/pyenv"))
  (require 'pyenv)
  (global-pyenv-mode t))

(when (file-exists-p "~/.pyenv/version")
  (ome-install 'pyenv))
