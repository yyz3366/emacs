(add-to-list 'auto-mode-alist '("SConstruct" . python-mode))

(defun ome-puppet-mode-setup ()
  (when (featurep 'evil)
    (add-hook 'puppet-mode-hook 'turn-on-evil-mode)))

(ome-install 'puppet-mode)

(when (executable-find "pacman")
  (ome-install 'pkgbuild-mode))

(defun dockerfile-mode-setup ())

(ome-install 'dockerfile-mode)

(defun ome-wikipedia-mode-setup ()
  (add-to-list 'auto-mode-alist
               '("\\.wiki\\'" . wikipedia-mode)))

(ome-install 'wikipedia-mode)

(defun ome-yaml-mode-setup ()
  (add-hook 'yaml-mode-hook
            (lambda ()
              (linum-mode 1)
              (evil-local-mode 1)
              (indent-guide-mode 1)))
  (add-to-list 'auto-mode-alist '("\\.raml\\'" . yaml-mode))
  (add-to-list 'ac-modes 'yaml-mode))

(ome-install 'yaml-mode)
