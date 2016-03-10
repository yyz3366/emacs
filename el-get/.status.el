((ac-slime status "installed" recipe
           (:name ac-slime :website "https://github.com/purcell/ac-slime" :description "Emacs auto-complete plugin for Slime symbols" :type github :depends
                  (slime)
                  :pkgname "purcell/ac-slime"))
 (ace-jump-mode status "installed" recipe
                (:name ace-jump-mode :website "https://github.com/winterTTr/ace-jump-mode/wiki" :description "A quick cursor location minor mode for emacs." :type github :pkgname "winterTTr/ace-jump-mode" :prepare
                       (eval-after-load "ace-jump-mode"
                         '(ace-jump-mode-enable-mark-sync))))
 (ag status "installed" recipe
     (:name ag :description "A simple ag frontend, loosely based on ack-and-half.el." :type github :pkgname "Wilfred/ag.el" :depends
            (dash s)))
 (alert status "installed" recipe
        (:name alert :description "Growl-style notification system for Emacs" :website "https://github.com/jwiegley/alert" :type github :pkgname "jwiegley/alert" :prepare
               (progn
                 (autoload 'alert "alert" "Alert the user that something has happened.")
                 (autoload 'alert-add-rule "alert" "Programmatically add an alert configuration rule."))))
 (auctex status "installed" recipe
         (:name auctex :website "http://www.gnu.org/software/auctex/" :description "AUCTeX is an extensible package for writing and formatting TeX files in GNU Emacs and XEmacs. It supports many different TeX macro packages, including AMS-TeX, LaTeX, Texinfo, ConTeXt, and docTeX (dtx files)." :type git :module "auctex" :url "git://git.savannah.gnu.org/auctex.git" :build
                `(("./autogen.sh")
                  ("./configure" "--without-texmf-dir" "--with-packagelispdir=$(pwd)" "--with-packagedatadir=$(pwd)" ,(concat "--with-emacs=" el-get-emacs))
                  ("make"))
                :build/darwin
                `(("./autogen.sh")
                  ("./configure" "--without-texmf-dir" "--with-packagelispdir=$(pwd)" "--with-packagedatadir=$(pwd)" "--with-lispdir=$(pwd)" ,(concat "--with-emacs=" el-get-emacs))
                  ("make"))
                :load-path
                (".")
                :load
                ("tex-site.el" "preview-latex.el")
                :info "doc"))
 (auto-complete status "installed" recipe
                (:name auto-complete :website "https://github.com/auto-complete/auto-complete" :description "The most intelligent auto-completion extension." :type github :pkgname "auto-complete/auto-complete" :depends
                       (popup fuzzy)
                       :features auto-complete-config :post-init
                       (progn
                         (add-to-list 'ac-dictionary-directories
                                      (expand-file-name "dict" default-directory))
                         (ac-config-default))))
 (auto-complete-clang status "installed" recipe
                      (:name auto-complete-clang :website "https://github.com/brianjcj/auto-complete-clang" :description "Auto-complete sources for Clang. Combine the power of AC, Clang and Yasnippet." :type github :pkgname "brianjcj/auto-complete-clang" :depends auto-complete))
 (calfw status "installed" recipe
        (:name calfw :type github :pkgname "kiwanami/emacs-calfw" :load-path "." :description "A calendar framework for Emacs (with support for `org-mode', `howm' and iCal files)" :website "https://github.com/kiwanami/emacs-calfw"))
 (cdlatex-mode status "installed" recipe
               (:name cdlatex-mode :description "a minor mode which re-implements many features also found in the AUCTeX LaTeX mode." :type http :url "http://staff.science.uva.nl/~dominik/Tools/cdlatex/cdlatex.el"))
 (chinese-word-at-point status "installed" recipe
                        (:name chinese-word-at-point :auto-generated t :type elpa :description "Add `chinese-word' thing to `thing-at-point'" :repo nil :depends
                               (cl-lib)))
 (cl-lib status "installed" recipe
         (:name cl-lib :builtin "24.3" :type elpa :description "Properly prefixed CL functions and macros" :url "http://elpa.gnu.org/packages/cl-lib.html"))
 (clojure-mode status "installed" recipe
               (:name clojure-mode :website "https://github.com/clojure-emacs/clojure-mode" :description "Emacs support for the Clojure language." :type github :pkgname "clojure-emacs/clojure-mode"))
 (company-mode status "installed" recipe
               (:name company-mode :website "http://company-mode.github.io/" :description "Modular in-buffer completion framework for Emacs" :type github :pkgname "company-mode/company-mode"))
 (dash status "installed" recipe
       (:name dash :description "A modern list api for Emacs. No 'cl required." :type github :pkgname "magnars/dash.el"))
 (diminish status "installed" recipe
           (:name diminish :description "An Emacs package that diminishes the amount of space taken on the mode line by the names of minor modes." :type http :url "http://www.eskimo.com/~seldon/diminish.el" :features diminish))
 (dockerfile-mode status "installed" recipe
                  (:name dockerfile-mode :description "An emacs mode for handling Dockerfiles." :type github :pkgname "spotify/dockerfile-mode" :prepare
                         (progn
                           (add-to-list 'auto-mode-alist
                                        '("Dockerfile\\'" . dockerfile-mode)))))
 (eclim status "installed" recipe
        (:name eclim :website "https://github.com/senny/emacs-eclim/" :description "This project brings some of the great eclipse features to emacs developers." :type github :pkgname "senny/emacs-eclim" :features eclim :depends
               (s)
               :post-init
               (progn
                 (setq eclim-auto-save t)
                 (global-eclim-mode -1))))
 (editorconfig status "installed" recipe
               (:name editorconfig :website "http://editorconfig.org" :description "Define and maintain consistent coding styles" :type github :branch "master" :pkgname "editorconfig/editorconfig-emacs"))
 (el-get status "installed" recipe
         (:name el-get :website "https://github.com/dimitri/el-get#readme" :description "Manage the external elisp bits and pieces you depend upon." :type github :branch "master" :pkgname "dimitri/el-get" :info "." :compile
                ("el-get.*\\.el$" "methods/")
                :features el-get :post-init
                (when
                    (memq 'el-get
                          (bound-and-true-p package-activated-list))
                  (message "Deleting melpa bootstrap el-get")
                  (unless package--initialized
                    (package-initialize t))
                  (when
                      (package-installed-p 'el-get)
                    (let
                        ((feats
                          (delete-dups
                           (el-get-package-features
                            (el-get-elpa-package-directory 'el-get)))))
                      (el-get-elpa-delete-package 'el-get)
                      (dolist
                          (feat feats)
                        (unload-feature feat t))))
                  (require 'el-get))))
 (elisp-slime-nav status "installed" recipe
                  (:name elisp-slime-nav :type github :pkgname "purcell/elisp-slime-nav" :description "Slime-style navigation for Emacs Lisp" :prepare
                         (add-hook 'emacs-lisp-mode-hook 'turn-on-elisp-slime-nav-mode)))
 (elpy status "installed" recipe
       (:name elpy :website "https://github.com/jorgenschaefer/elpy" :description "Emacs Python Development Environment" :type github :pkgname "jorgenschaefer/elpy" :post-init
              (el-get-envpath-prepend "PYTHONPATH" default-directory)
              :depends
              (company-mode yasnippet highlight-indentation find-file-in-project idomenu pyvenv)))
 (emacs-w3m status "installed" recipe
            (:name emacs-w3m :description "A simple Emacs interface to w3m" :type cvs :website "http://emacs-w3m.namazu.org/" :module "emacs-w3m" :url ":pserver:anonymous@cvs.namazu.org:/storage/cvsroot" :build
                   `(("autoconf")
                     ("./configure" ,(format "--with-emacs=%s" el-get-emacs))
                     ("make"))
                   :build/windows-nt
                   (("sh" "./autogen.sh")
                    ("sh" "./configure")
                    ("make"))
                   :info "doc"))
 (epl status "installed" recipe
      (:name epl :description "EPL provides a convenient high-level API for various package.el versions, and aims to overcome its most striking idiocies." :type github :pkgname "cask/epl"))
 (evil status "installed" recipe
       (:name evil :website "https://bitbucket.org/lyro/evil" :description "Evil is an extensible vi layer for Emacs. It\n       emulates the main features of Vim, and provides facilities\n       for writing custom extensions." :type hg :url "https://bitbucket.org/lyro/evil" :features evil :depends
              (undo-tree goto-chg)
              :build
              (("make" "info" "all"))
              :build/berkeley-unix
              (("gmake" "info" "all"))
              :build/darwin
              `(("make" ,(format "EMACS=%s" el-get-emacs)
                 "info" "all"))
              :info "doc"))
 (evil-escape status "installed" recipe
              (:name evil-escape :website "https://github.com/syl20bnr/evil-escape" :description "Customizable key sequence to escape from insert state and everything else in Emacs." :type github :pkgname "syl20bnr/evil-escape" :depends evil))
 (evil-leader status "installed" recipe
              (:name evil-leader :website "http://github.com/cofi/evil-leader" :description "Add <leader> shortcuts to Evil, the extensible vim\n       emulation layer" :type github :pkgname "cofi/evil-leader" :features evil-leader :depends evil))
 (evil-org-mode status "installed" recipe
                (:name evil-org-mode :website "http://github.com/edwtjo/evil-org-mode" :description "Supplemental evil-mode keybindings to emacs org-mode." :type github :pkgname "edwtjo/evil-org-mode" :depends
                       (evil evil-leader)))
 (evil-surround status "installed" recipe
                (:name evil-surround :website "http://github.com/timcharper/evil-surround" :description "Emulate Tim Pope's surround.vim in evil, the extensible vim\n       emulation layer for emacs" :type github :pkgname "timcharper/evil-surround" :features evil-surround :post-init
                       (global-evil-surround-mode 1)
                       :depends evil))
 (exec-path-from-shell status "installed" recipe
                       (:name exec-path-from-shell :website "https://github.com/purcell/exec-path-from-shell" :description "Emacs plugin for dynamic PATH loading" :type github :pkgname "purcell/exec-path-from-shell"))
 (expand-region status "installed" recipe
                (:name expand-region :type github :pkgname "magnars/expand-region.el" :description "Expand region increases the selected region by semantic units. Just keep pressing the key until it selects what you want." :website "https://github.com/magnars/expand-region.el#readme"))
 (find-file-in-project status "installed" recipe
                       (:name find-file-in-project :type github :pkgname "technomancy/find-file-in-project" :description "Quick access to project files in Emacs"))
 (flycheck status "installed" recipe
           (:name flycheck :type github :pkgname "flycheck/flycheck" :minimum-emacs-version "24.3" :description "On-the-fly syntax checking extension" :build
                  '(("makeinfo" "-o" "doc/flycheck.info" "doc/flycheck.texi"))
                  :info "./doc" :depends
                  (dash pkg-info let-alist seq)))
 (fringe-helper status "installed" recipe
                (:name fringe-helper :description "Helper functions for fringe bitmaps." :type github :pkgname "nschum/fringe-helper.el"))
 (fuzzy status "installed" recipe
        (:name fuzzy :website "https://github.com/auto-complete/fuzzy-el" :description "Fuzzy matching utilities for GNU Emacs" :type github :pkgname "auto-complete/fuzzy-el"))
 (git-gutter status "installed" recipe
             (:name git-gutter :description "Emacs port of GitGutter Sublime Text 2 Plugin" :website "https://github.com/syohex/emacs-git-gutter" :type github :pkgname "syohex/emacs-git-gutter"))
 (git-gutter-fringe status "installed" recipe
                    (:name git-gutter-fringe :type github :pkgname "syohex/emacs-git-gutter-fringe" :description "Fringe version of git-gutter.el" :depends
                           (git-gutter fringe-helper)))
 (goto-chg status "installed" recipe
           (:name goto-chg :description "Goto the point of the most recent edit in the buffer." :type emacswiki :features goto-chg))
 (haskell-mode status "installed" recipe
               (:name haskell-mode :description "A Haskell editing mode" :type github :pkgname "haskell/haskell-mode" :info "." :build
                      `(("make" ,(format "EMACS=%s" el-get-emacs)
                         "all"))
                      :post-init
                      (progn
                        (require 'haskell-mode-autoloads)
                        (add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
                        (add-hook 'haskell-mode-hook 'turn-on-haskell-indentation))))
 (helm status "installed" recipe
       (:name helm :description "Emacs incremental completion and narrowing framework" :type github :pkgname "emacs-helm/helm" :autoloads "helm-autoloads" :build
              (("make"))
              :build/darwin
              `(("make" ,(format "EMACS_COMMAND=%s" el-get-emacs)))
              :build/windows-nt
              (let
                  ((generated-autoload-file
                    (expand-file-name "helm-autoloads.el"))
                   \
                   (backup-inhibited t))
              (update-directory-autoloads default-directory)
              nil)
       :features "helm-config" :post-init
       (helm-mode)))
(helm-ag status "installed" recipe
(:name helm-ag :description "The silver search with helm interface." :type github :pkgname "syohex/emacs-helm-ag" :depends
(helm)))
(helm-descbinds status "installed" recipe
(:name helm-descbinds :type github :pkgname "emacs-helm/helm-descbinds" :description "Yet Another `describe-bindings' with `helm'." :depends
(helm)
:prepare
(progn
(autoload 'helm-descbinds-install "helm-descbinds"))))
(highlight-indentation status "installed" recipe
(:name highlight-indentation :description "Function for highlighting indentation" :type git :url "https://github.com/antonj/Highlight-Indentation-for-Emacs"))
(htmlize status "installed" recipe
(:type github :pkgname "emacsmirror/htmlize" :name htmlize :website "http://www.emacswiki.org/emacs/Htmlize" :description "Convert buffer text and decorations to HTML." :type emacsmirror :localname "htmlize.el"))
(idomenu status "installed" recipe
(:name idomenu :type emacswiki :description "imenu tag selection a la ido" :load-path "."))
(indent-guide status "installed" recipe
(:name indent-guide :description "show vertical lines to guide indentation." :website "https://github.com/zk-phi/indent-guide" :type github :pkgname "zk-phi/indent-guide"))
(inf-ruby status "installed" recipe
(:name inf-ruby :description "Inferior Ruby Mode - ruby process in a buffer." :type github :pkgname "nonsequitur/inf-ruby"))
(let-alist status "installed" recipe
(:name let-alist :description "Easily let-bind values of an assoc-list by their names." :builtin "25.0.50" :type elpa :url "https://elpa.gnu.org/packages/let-alist.html"))
(linum-relative status "installed" recipe
(:name linum-relative :type emacswiki :description "Display relative line number in the left margin" :features linum-relative))
(magit status "installed" recipe
(:name magit :website "https://github.com/magit/magit#readme" :description "It's Magit! An Emacs mode for Git." :type github :pkgname "magit/magit" :branch "master" :minimum-emacs-version "24.4" :depends
(dash)
:provide
(with-editor)
:info "Documentation" :load-path "lisp/" :compile "lisp/" :build
`(("make" ,(format "EMACSBIN=%s" el-get-emacs)
"docs")
("touch" "lisp/magit-autoloads.el"))
:build/berkeley-unix
`(("gmake" ,(format "EMACSBIN=%s" el-get-emacs)
"docs")
("touch" "lisp/magit-autoloads.el"))
:build/windows-nt
(with-temp-file "lisp/magit-autoloads.el" nil)))
(markdown-mode status "installed" recipe
(:name markdown-mode :description "Major mode to edit Markdown files in Emacs" :website "http://jblevins.org/projects/markdown-mode/" :type git :url "git://jblevins.org/git/markdown-mode.git" :prepare
(add-to-list 'auto-mode-alist
'("\\.\\(md\\|mdown\\|markdown\\)\\'" . markdown-mode))))
(names status "installed" recipe
(:name names :description "A Namespace implementation for Emacs-Lisp" :website "https://github.com/Bruce-Connor/names" :type github :depends cl-lib :pkgname "Bruce-Connor/names"))
(org-doing status "installed" recipe
(:name org-doing :website "http://omouse.github.io/org-doing/" :description "Keep track of what you're doing right now and what you've worked on before." :type github :pkgname "omouse/org-doing" :depends
(org-mode)))
(org-jekyll status "installed" recipe
(:name org-jekyll :description "Blog from org-mode using jekyll" :type github :pkgname "juanre/org-jekyll" :features org-jekyll))
(org-mode status "installed" recipe
(:name org-mode :website "http://orgmode.org/" :description "Org-mode is for keeping notes, maintaining ToDo lists, doing project planning, and authoring with a fast and effective plain-text system." :type git :url "git://orgmode.org/org-mode.git" :info "doc" :build/berkeley-unix `,(mapcar
(lambda
(target)
(list "gmake" target
(concat "EMACS="
(shell-quote-argument el-get-emacs))))
'("oldorg"))
:build `,(mapcar
(lambda
(target)
(list "make" target
(concat "EMACS="
(shell-quote-argument el-get-emacs))))
'("oldorg"))
:load-path
("." "contrib/lisp" "lisp")
:load
("lisp/org-loaddefs.el")))
(org-pomodoro status "installed" recipe
(:name org-pomodoro :description "This adds support for Pomodoro technique in org-mode." :type github :depends
(alert)
:pkgname "lolownia/org-pomodoro"))
(package status "installed" recipe
(:name package :description "ELPA implementation (\"package.el\") from Emacs 24" :builtin "24" :type http :url "http://repo.or.cz/w/emacs.git/blob_plain/ba08b24186711eaeb3748f3d1f23e2c2d9ed0d09:/lisp/emacs-lisp/package.el" :shallow nil :features package :post-init
(progn
(let
((old-package-user-dir
(expand-file-name
(convert-standard-filename
(concat
(file-name-as-directory default-directory)
"elpa")))))
(when
(file-directory-p old-package-user-dir)
(add-to-list 'package-directory-list old-package-user-dir)))
(setq package-archives
(bound-and-true-p package-archives))
(mapc
(lambda
(pa)
(add-to-list 'package-archives pa 'append))
'(("ELPA" . "http://tromey.com/elpa/")
("melpa" . "http://melpa.org/packages/")
("gnu" . "http://elpa.gnu.org/packages/")
("marmalade" . "http://marmalade-repo.org/packages/")
("SC" . "http://joseito.republika.pl/sunrise-commander/"))))))
(pkg-info status "installed" recipe
(:name pkg-info :description "Provide information about Emacs packages." :type github :pkgname "lunaryorn/pkg-info.el" :depends
(dash epl)))
(popup status "installed" recipe
(:name popup :website "https://github.com/auto-complete/popup-el" :description "Visual Popup Interface Library for Emacs" :type github :submodule nil :depends cl-lib :pkgname "auto-complete/popup-el"))
(projectile status "installed" recipe
(:name projectile :description "Project navigation and management library for Emacs." :type github :pkgname "bbatsov/projectile" :depends
(dash pkg-info)))
(puppet-mode status "installed" recipe
(:name puppet-mode :description "A simple mode for editing puppet manifests" :type github :pkgname "lunaryorn/puppet-mode" :website "https://github.com/lunaryorn/puppet-mode" :prepare
(progn
(autoload 'puppet-mode "puppet-mode" "Major mode for editing puppet manifests" t)
(add-to-list 'auto-mode-alist
'("\\.pp$" . puppet-mode)))))
(pyvenv status "installed" recipe
(:name pyvenv :website "https://github.com/jorgenschaefer/pyvenv" :description "Python virtual environment interface for Emacs" :type github :pkgname "jorgenschaefer/pyvenv" :post-init
(el-get-envpath-prepend "PYTHONPATH" default-directory)))
(quickrun status "installed" recipe
(:name quickrun :description "Run commands quickly" :website "https://github.com/syohex/emacs-quickrun" :type github :pkgname "syohex/emacs-quickrun" :features "quickrun"))
(rainbow-delimiters status "installed" recipe
(:name rainbow-delimiters :website "https://github.com/Fanael/rainbow-delimiters#readme" :description "Color nested parentheses, brackets, and braces according to their depth." :type github :pkgname "Fanael/rainbow-delimiters"))
(rainbow-mode status "installed" recipe
(:name rainbow-mode :description "Colorize color names in buffers" :type elpa :prepare
(autoload 'rainbow-turn-on "rainbow-mode")))
(robe-mode status "installed" recipe
(:name robe-mode :type github :description "Code navigation, documentation lookup and completion for Ruby" :pkgname "dgutov/robe" :website "https://github.com/dgutov/robe" :depends
(inf-ruby)
:post-init
(add-hook 'ruby-mode-hook 'robe-mode)))
(s status "installed" recipe
(:name s :description "The long lost Emacs string manipulation library." :type github :pkgname "magnars/s.el"))
(seq status "installed" recipe
(:name seq :description "Sequence manipulation library for Emacs" :builtin "25" :type github :pkgname "NicolasPetton/seq.el"))
(slime status "installed" recipe
(:name slime :description "Superior Lisp Interaction Mode for Emacs" :type github :autoloads "slime-autoloads" :info "doc" :pkgname "slime/slime" :depends cl-lib :load-path
("." "contrib")
:build
'(("sed" "-i" "s/@itemx INIT-FUNCTION/@item INIT-FUNCTION/" "doc/slime.texi")
("make" "-C" "doc" "slime.info"))
:build/darwin
'(("make" "-C" "doc" "slime.info"))
:build/berkeley-unix
'(("gmake" "-C" "doc" "slime.info"))
:post-init
(slime-setup)))
(smartparens status "installed" recipe
(:name smartparens :description "Autoinsert pairs of defined brackets and wrap regions" :type github :pkgname "Fuco1/smartparens" :depends dash))
(smex status "installed" recipe
(:name smex :description "M-x interface with Ido-style fuzzy matching." :type github :pkgname "nonsequitur/smex" :features smex :post-init
(smex-initialize)))
(solarized-emacs status "installed" recipe
(:name solarized-emacs :description "Solarized for Emacs is an Emacs port of the Solarized theme for vim, developed by Ethan Schoonover." :website "https://github.com/bbatsov/solarized-emacs" :minimum-emacs-version "24" :type github :pkgname "bbatsov/solarized-emacs" :depends dash :prepare
(add-to-list 'custom-theme-load-path default-directory)))
(undo-tree status "installed" recipe
(:name undo-tree :description "Treat undo history as a tree" :website "http://www.dr-qubit.org/emacs.php" :type git :url "http://www.dr-qubit.org/git/undo-tree.git/"))
(web-mode status "installed" recipe
(:name web-mode :description "emacs major mode for editing PHP/JSP/ASP HTML templates (with embedded CSS and JS blocks)" :type github :pkgname "fxbois/web-mode"))
(wikipedia-mode status "installed" recipe
(:name wikipedia-mode :description "Mode for editing Wikipedia articles off-line" :type emacswiki :features wikipedia-mode :prepare
(add-to-list 'auto-mode-alist
'("\\.wiki\\.txt\\'" . wikipedia-mode))))
(window-number status "installed" recipe
(:type github :pkgname "emacsmirror/window-number" :name window-number :description "Select windows by numbers" :type emacsmirror :prepare
(progn
(autoload 'window-number-mode "window-number" "A global minor mode that enables selection of windows according to\nnumbers with the C-x C-j prefix.  Another mode,\n`window-number-meta-mode' enables the use of the M- prefix." t)
(autoload 'window-number-meta-mode "window-number" "A global minor mode that enables use of the M- prefix to select\nwindows, use `window-number-mode' to display the window numbers in\nthe mode-line." t)
(defun window-number-mode-on nil "Turn on `window-number-mode' mode."
(interactive)
(window-number-mode 1))
(defun window-number-meta-mode-on nil "Turn on `window-number-meta-mode' mode."
(interactive)
(window-number-meta-mode 1)))))
(window-numbering status "installed" recipe
(:name window-numbering :website "http://nschum.de/src/emacs/window-numbering-mode/" :description "Assigns numbers to Emacs windows to allow easy window navigation." :type github :pkgname "nschum/window-numbering.el"))
(xcscope status "installed" recipe
(:name xcscope :description "Cscope interface for (X)Emacs" :type github :pkgname "dkogan/xcscope.el" :prepare
(progn
(add-hook 'c-mode-hook #'cscope-minor-mode)
(add-hook 'c++-mode-hook #'cscope-minor-mode)
(add-hook 'dired-mode-hook #'cscope-minor-mode))))
(yaml-mode status "installed" recipe
(:name yaml-mode :description "Simple major mode to edit YAML file for emacs" :type github :pkgname "yoshiki/yaml-mode"))
(yard-mode status "installed" recipe
(:name yard-mode :description "Yet another Ruby Documentation mode" :type github :pkgname "pd/yard-mode.el"))
(yasnippet status "installed" recipe
(:name yasnippet :website "https://github.com/capitaomorte/yasnippet.git" :description "YASnippet is a template system for Emacs." :type github :pkgname "capitaomorte/yasnippet" :compile "yasnippet.el" :submodule nil :build
(("git" "submodule" "update" "--init" "--" "snippets"))))
(youdao-dictionary status "installed" recipe
(:name youdao-dictionary :auto-generated t :type elpa :description "Youdao Dictionary interface for Emacs" :repo nil :depends
(popup chinese-word-at-point names)
:minimum-emacs-version
(24))))
