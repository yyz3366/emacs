(defun ome-eclim-setup ()
  ;; (add-to-list 'eclim-eclipse-dirs "/opt/eclipse")
  (setq eclim-auto-save t
        eclim-executable (or (executable-find "eclim") "/opt/eclipse/eclim")
        eclimd-executable (or (executable-find "eclimd") "/opt/eclipse/eclimd")
        eclimd-wait-for-process nil
        eclimd-default-workspace "~/workspace/"
        help-at-pt-display-when-idle t
        help-at-pt-timer-delay 0.1)

  ;; Call the help framework with the settings above & activate
  ;; eclim-mode
  (help-at-pt-set-timer)

  ;; keep consistent which other auto-complete backend.
  (custom-set-faces
   '(ac-emacs-eclim-candidate-face ((t (:inherit ac-candidate-face))))
   '(ac-emacs-eclim-selection-face ((t (:inherit ac-selection-face)))))

  ;; Hook eclim up with auto complete mode
  (require 'ac-emacs-eclim-source)
  ;; (ac-emacs-eclim-config)

  (require 'eclimd)

  (add-hook 'java-mode-hook
            (lambda ()
              (add-to-list 'ac-sources 'ac-source-emacs-eclim)
              (eclim-mode t))))

(when (executable-find "eclipse")
  (ome-install 'eclim))
