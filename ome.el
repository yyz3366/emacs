(when (version< emacs-version "24.3")
  (el-get 'sync '(cl-lib))
  (add-to-list 'load-path "~/.emacs.d/el-get/cl-lib"))

(defvar ome-packages nil
  "This package contains all packages loaded by oh-my-emacs.

Acutally, this variable is an alist, whose element is also a
list. The car of the element is an oh-my-emacs module name, while
the cdr of the element is a list of el-get packages loaded in particular
oh-my-emacs module.")

(defun ome-load (module &rest header-or-tags)
  "Load configuration from other ome-*.org files.
If the optional argument is the id of a subtree then only
configuration from within that subtree will be loaded.  If it is
not an id then it will be interpreted as a tag, and only subtrees
marked with the given tag will be loaded.

For example, to load all of ome-lisp.org simply add (ome-load
\"ome-lisp\") to your configuration.

To load only the 'window-system' config from ome-miscs.org
add (ome-load \"ome-miscs.org\" \"window-system\") to your
configuration.

The good news is, you can load multiple parts config from one
single file by simply (ome-load \"ome-module.org\" \"part1\"
\"part2\")."
  (let ((module-name (file-name-base module))
        (file (expand-file-name (if (string-match "ome-.+\.org" module)
                                    module
                                  (format "ome-%s.org" module))
                                ome-dir)))
    ;; ensure el-get-sources is empty before loading "ome-.+\.org" files
    (setq el-get-sources nil)
    ;; enable git shallow clone to save time and bandwidth
    (setq el-get-git-shallow-clone t)

    (if header-or-tags
        (dolist (header-or-tag header-or-tags)
          (let* ((base (file-name-nondirectory file))
                 (dir  (file-name-directory file))
                 (partial-file (expand-file-name
                                (concat "." (file-name-sans-extension base)
                                        ".part." header-or-tag ".org")
                                dir)))
            (unless (file-exists-p partial-file)
              (with-temp-file partial-file
                (insert
                 (with-temp-buffer
                   (insert-file-contents file)
                   (save-excursion
                     (condition-case nil ;; collect as a header
                         (progn
                           (org-link-search (concat "#" header-or-tag))
                           (org-narrow-to-subtree)
                           (buffer-string))
                       (error ;; collect all entries with as tags
                        (let (body)
                          (org-map-entries
                           (lambda ()
                             (save-restriction
                               (org-narrow-to-subtree)
                               (setq body (concat body "\n" (buffer-string)))))
                           header-or-tag)
                          body))))))))
            (org-babel-load-file partial-file)))
      (org-babel-load-file file))

    (el-get 'sync (mapcar 'el-get-source-name el-get-sources))
    (setq ome-module-packages nil)
    (mapcar (lambda (el-get-package)
              (add-to-list 'ome-module-packages
                           (el-get-source-name el-get-package)))
            el-get-sources)
    (add-to-list 'ome-packages
                 (cons module-name ome-module-packages))))

(defun ome-install (el-get-package)
  "Add EL-GET-PACKAGE to `el-get-sources'.

This package will be installed when `ome-load'. Users can make
his own customization by providing a \"ome-package-name-setup\"
function."
  (let ((ome-package-setup-func
         (intern
          (concat "ome-"
                  (el-get-as-string el-get-package)
                  "-setup"))))
    (if (fboundp ome-package-setup-func)
        (add-to-list 'el-get-sources
                     `(:name ,el-get-package
                             :after (progn
                                      (,ome-package-setup-func))))
      (add-to-list 'el-get-sources
                   `(:name ,el-get-package)))))

(defun ome-try-get-package-website (package)
  "el-get's package recipe has multiple type, some contains
a :website, some contains just a :url, while some github package
just contains a :pkgname. This function try to get a proper
website link for an el-get package."
  (let ((package-def (el-get-package-def package)))
    (or (plist-get package-def :website)
        (and (eq (plist-get package-def :type) 'github)
             (concat "https://github.com/"
                     (plist-get package-def :pkgname)))
        (plist-get package-def :url))))

(defun ome-try-get-package-description (package)
  "This function try to get a proper description for an el-get
package from its recipe. Note that some package's description has
multiple lines, so we need to join them together for better
auto-fill."
  (let ((package-def (el-get-package-def package)))
    (replace-regexp-in-string "\\(\n\\|\\ \\)+" " "
                              (plist-get package-def :description))))

(defun ome-package-list-to-org-table ()
  (interactive)
  (setq ome-packages (sort ome-packages
                           #'(lambda (x y) (string< (car x) (car y)))))
  (let ((org-table-line-template "|%s|[[%s][%s]]|%s|\n"))
    (with-temp-buffer
      (insert "| Module | Package | Description |\n")
      (insert "|--------+---------+-------------|\n")
      (insert "")
      (dolist (module-packages ome-packages)
        (setq package-index 0)
        (dolist (package (cdr module-packages))
          (insert (format org-table-line-template
                          (if (= package-index 0)
                              (car module-packages)
                            "")
                          (ome-try-get-package-website package)
                          package
                          (ome-try-get-package-description package)))
          (incf package-index)))
      (buffer-string))))

(add-to-list 'el-get-sources
             '(:name cl-lib))

(defun ome-start-or-switch-to (function buffer-name)
  "Invoke FUNCTION if there is no buffer with BUFFER-NAME.
  Otherwise switch to the buffer named BUFFER-NAME.  Don't clobber
  the current buffer."
  (if (not (get-buffer buffer-name))
      (progn
        (split-window-sensibly (selected-window))
        (other-window 1)
        (funcall function))
    (switch-to-buffer-other-window buffer-name)))

(ome-load "core/ome-basic.org")
(ome-load "core/ome-completion.org")
(ome-load "core/ome-auto-mode.org")
(ome-load "core/ome-gui.org")
(ome-load "core/ome-keybindings.org")
(ome-load "core/ome-miscs.org")
(ome-load "core/ome-org.org")
(ome-load "core/ome-writing.org")
(ome-load "core/ome-advanced.org")
(ome-load "modules/ome-cc.org")
(ome-load "modules/ome-java.org")
(ome-load "modules/ome-emacs-lisp.org")
(ome-load "modules/ome-common-lisp.org")
(ome-load "modules/ome-clojure.org")
(ome-load "modules/ome-scheme.org")
(ome-load "modules/ome-python.org")
(ome-load "modules/ome-ruby.org")
(ome-load "modules/ome-ocaml.org")
(ome-load "modules/ome-tex.org")
(ome-load "modules/ome-web.org")
;; (ome-load "modules/ome-experimental.org" "smooth-scrolling" "sublimity")
(ome-load "modules/ome-haskell.org")
(ome-load "modules/ome-sml.org")
(ome-load "modules/ome-golang.org")

(setq custom-file (expand-file-name "custom.el" ome-dir))
(load custom-file 'noerror)

(flet ((sk-load (base)
         (let* ((path          (expand-file-name base ome-dir))
                (literate      (concat path ".org"))
                (encrypted-org (concat path ".org.gpg"))
                (plain         (concat path ".el"))
                (encrypted-el  (concat path ".el.gpg")))
           (cond
            ((file-exists-p encrypted-org) (org-babel-load-file encrypted-org))
            ((file-exists-p encrypted-el)  (load encrypted-el))
            ((file-exists-p literate)      (org-babel-load-file literate))
            ((file-exists-p plain)         (load plain)))))
       (remove-extension (name)
         (string-match "\\(.*?\\)\.\\(org\\(\\.el\\)?\\|el\\)\\(\\.gpg\\)?$" name)
         (match-string 1 name)))
  (let ((elisp-dir (expand-file-name "src" ome-dir))
        (user-dir (expand-file-name user-login-name ome-dir)))
    ;; add the src directory to the load path
    (add-to-list 'load-path elisp-dir)
    ;; load specific files
    (when (file-exists-p elisp-dir)
      (let ((default-directory elisp-dir))
        (normal-top-level-add-subdirs-to-load-path)))
    ;; load system-specific config
    (sk-load system-name)
    ;; load user-specific config
    (sk-load user-login-name)
    ;; load any files in the user's directory
    (when (file-exists-p user-dir)
      (add-to-list 'load-path user-dir)
      (mapc #'sk-load
            (remove-duplicates
             (mapcar #'remove-extension
                     (directory-files user-dir t ".*\.\\(org\\|el\\)\\(\\.gpg\\)?$"))
             :test #'string=)))))
