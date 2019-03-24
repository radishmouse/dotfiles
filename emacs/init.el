
;; =================================================
;; Package things
;; =================================================

(package-initialize)
(setq package-archives
      '(("org" . "http://orgmode.org/elpa/")
        ("gnu" . "http://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")
        ("melpa-stable" . "https://stable.melpa.org/packages/")
        ("marmalade" . "http://marmalade-repo.org/packages/")))
(add-to-list 'package-pinned-packages '(cider . "melpa-stable") t)

;; (setq package-archive-priorities '(("org" . 1)
                                   ;; ("melpa-stable" . 2)
                                   ;; ("melpa" . 3)
                                   ;; ("gnu" . 4)
                                   ;; ("marmalade" . 5)
                                   ;; ))
;; Uncomment when you're setting up
;; (package-refresh-contents)
;; This makes sure that you can package-install 'use-package.

(unless (package-installed-p 'use-package)
 (package-install 'use-package))


(defconst is-machine-mac (eq system-type 'darwin) "macOS")


;; =================================================
;; UI
;; =================================================

;; Some of following were lifted from `better-defaults` package
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))
(when (fboundp 'menu-bar-mode)
  (menu-bar-mode -1))
(when (fboundp 'horizontal-scroll-bar-mode)
  (horizontal-scroll-bar-mode -1))

(setq inhibit-splash-screen t)

;; remembers where you were in a file
(use-package saveplace
  :ensure t
  :init
 (setq-default save-place t)
 ;; (save-place-mode 1)
 ;; why this no worky?
 )


(show-paren-mode 1)

(setq-default indent-tabs-mode nil)

(setq x-select-enable-clipboard t
      x-select-enable-primary t
      save-interprogram-paste-before-kill t
      apropos-do-all t
      mouse-yank-at-point t
      require-final-newline t
      visible-bell nil
      ring-bell-function 'ignore
      load-prefer-newer t
      ediff-window-setup-function 'ediff-setup-windows-plain
      save-place-file (concat user-emacs-directory "places")
      local-cache-dir (concat user-emacs-directory "cache")
      auto-save-file-name-transforms `((".*" ,(concat user-emacs-directory
                                               "auto-save") t))
      backup-directory-alist `(("." . ,(concat user-emacs-directory
                                               "backups"))))


(defalias 'yes-or-no-p 'y-or-n-p)


(global-auto-revert-mode 1)
;; (setq auto-revert-verbose nil)


;; fixes issue on OpenBSD: freezing on paste from clipboard
(setq save-interprogram-paste-before-kill t)


;; =================================================
;; Mac things
;; =================================================
(setq mac-option-modifier 'meta)

;; =================================================
;; Theme
;; =================================================

;; (use-package naquadah-theme
  ;; :ensure t
  ;; :config
  ;; (load-theme 'naquadah t))

;; this will crap out on my other systems...
;; (add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
;; (load-theme `cyberpunk-2019 t)

;; This one is pretty good :)
(use-package cyberpunk-theme
  :ensure t
  :config
  (load-theme 'cyberpunk t))

(set-cursor-color "green")

;; don't need these with naquadah
(global-hl-line-mode -1)
(blink-cursor-mode -1)

(delete-selection-mode t)

(setq scroll-margin 1
      scroll-conservatively 0
      scroll-up-aggressively 0.01
      scroll-down-aggressively 0.01)
(setq-default scroll-up-aggressively 0.01
              scroll-down-aggressively 0.01)

(cond ((member "Inconsolata" (font-family-list))
       (set-face-attribute 'default nil :font "Inconsolata-12")
       (if is-machine-mac
           (set-face-attribute 'default nil :font "Inconsolata-18"))))

;;((member "Source Code Pro" (font-family-list))
       ;; (set-face-attribute 'default nil :font "Source Code Pro-11"))




;; (use-package evil
  ;; :ensure t
  ;; :config
  ;; (use-package evil-leader
    ;; :ensure t
    ;; :config
    ;; (global-evil-leader-mode)
    ;; (setq evil-leader/in-all-states 1)
    ;; (evil-leader/set-leader ",")
    ;; (evil-leader/set-key
      ;; "b" 'switch-to-buffer
      ;; "e" 'find-file
      ;; "k" 'kill-buffer
      ;; ))
  ;; (evil-mode)
  ;; (use-package linum-relative
    ;; :config
    ;; (linum-relative-global-mode)))

;; =================================================
;; ivy
;; =================================================

(use-package ivy
  :ensure t
  :config
  (ivy-mode 1)
  (setq ivy-height 20
        ivy-use-virtual-buffers t)
  ; Use Enter on a directory to navigate into the directory, not open it with dired.
  (define-key ivy-minibuffer-map (kbd "C-m") 'ivy-alt-done)

  (use-package counsel
    :ensure t
    :config
    (global-set-key (kbd "C-s") 'counsel-grep-or-swiper)
    (global-set-key (kbd "M-x") 'counsel-M-x)
    (global-set-key (kbd "M-y") 'counsel-yank-pop)
    (global-set-key (kbd "C-x C-f") 'counsel-find-file)
    (global-set-key (kbd "C-h f") 'counsel-describe-function)
    (global-set-key (kbd "C-h v") 'counsel-describe-variable)
    ;; (global-set-key (kbd "<f1> l") 'counsel-load-library)
    ;; (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
    ;; (global-set-key (kbd "<f2> u") 'counsel-unicode-char)

    (use-package flx
      :config
      (setq ivy-re-builders-alist
          '((read-file-name-internal . ivy--regex-fuzzy)
            (counsel-M-x . ivy--regex-fuzzy)
            (ivy-switch-buffer . ivy--regex-fuzzy)
            (t . ivy--regex-plus))))
    ; Let ivy use flx for fuzzy-matching
    ;; (use-package flx
      ;; :config
    ;; (setq ivy-re-builders-alist '((t . ivy--regex-fuzzy)))))
    ))

;; =================================================
;; which-key
;; =================================================

(use-package which-key :ensure t)


;; =================================================
;; Multiple cursors
;; =================================================
(use-package multiple-cursors
  :ensure t
  :bind
  ("C->" . mc/mark-next-like-this)
  ("C-<" . mc/mark-previous-like-this)
  ("C-c C-<" . mc/mark-all-like-this))

;; =================================================
;; Rainbow Delimiters
;; =================================================
(use-package rainbow-delimiters
    :ensure t
    :config
    (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

    ;; This is a weird dance I have to do to get
    ;; rainbow-delimiters to work, as per
    ;; https://github.com/sellout/emacs-color-theme-solarized/issues/165
    ;; (outline-minor-mode t)
    ;; (outline-minor-mode nil)
    )

;; =================================================
;; Folding
;; =================================================
(use-package yafolding
  :ensure t)

;; =================================================
;; Undo
;; =================================================

(use-package undohist
  :ensure t
  :config
  (setq undohist-ignored-files '("/tmp" "COMMIT_EDITMSG"))
  (undohist-initialize))

(use-package undo-tree
  :ensure t
  :config
  (global-undo-tree-mode))


;; =================================================
;; Window manipulation
;; =================================================

(windmove-default-keybindings)
(winner-mode 1)

(defun my-split-root-window (size direction)
  (split-window (frame-root-window)
                (and size (prefix-numeric-value size))
                direction))

(defun my-split-root-window-below (&optional size)
  (interactive "P")
  (my-split-root-window size 'below))

(defun my-split-root-window-right (&optional size)
  (interactive "P")
  (my-split-root-window size 'right))

(defun my-split-root-window-left (&optional size)
  (interactive "P")
  (my-split-root-window size 'left))


(use-package ace-window
  :ensure t
  :config
  (setq aw-scope 'frame)
  :bind (("C-'"   . ace-window)
         ("C-;"   . avy-goto-char-timer)
         ("C-M-;" . avy-goto-line)))

(setq-default cursor-in-non-selected-windows 'block)

(use-package hydra
  :ensure t
  :config
  (defun hydra-move-splitter-left (arg)
    "Move window splitter left."
    (interactive "p")
    (if (let ((windmove-wrap-around))
          (windmove-find-other-window 'right))
        (shrink-window-horizontally arg)
      (enlarge-window-horizontally arg)))

  (defun hydra-move-splitter-right (arg)
    "Move window splitter right."
    (interactive "p")
    (if (let ((windmove-wrap-around))
          (windmove-find-other-window 'right))
        (enlarge-window-horizontally arg)
      (shrink-window-horizontally arg)))

  (defun hydra-move-splitter-up (arg)
    "Move window splitter up."
    (interactive "p")
    (if (let ((windmove-wrap-around))
          (windmove-find-other-window 'up))
        (enlarge-window arg)
      (shrink-window arg)))

  (defun hydra-move-splitter-down (arg)
    "Move window splitter down."
    (interactive "p")
    (if (let ((windmove-wrap-around))
          (windmove-find-other-window 'up))
        (shrink-window arg)
      (enlarge-window arg)))  
  (defhydra imagex-sticky-binding (global-map "C-x C-l")
    "Manipulating Image"
    ("+" imagex-sticky-zoom-in "zoom in")
    ("-" imagex-sticky-zoom-out "zoom out")
    ("M" imagex-sticky-maximize "maximize")
    ("O" imagex-sticky-restore-original "restore original")
    ("S" imagex-sticky-save-image "save file")
    ("r" imagex-sticky-rotate-right "rotate right")
    ("l" imagex-sticky-rotate-left "rotate left"))
  (defhydra hydra-zoom (global-map "<f5>")
    "zoom"
    ("g" text-scale-increase "in")
    ("l" text-scale-decrease "out"))
  (defhydra hydra-splitter (global-map "<f4>")
    "splitter"
    ("h" hydra-move-splitter-left)
    ("j" hydra-move-splitter-down)
    ("k" hydra-move-splitter-up)
    ("l" hydra-move-splitter-right)))



;; =================================================
;; origami-mode (code folding)
;; =================================================

(use-package origami
  :ensure t
  :bind (("C-c TAB" . origami-recursively-toggle-node)))
(add-hook 'prog-mode-hook 'origami-mode)


;; =================================================
;; writegood
;; =================================================

(use-package writegood-mode
  :ensure t
  :diminish writegood-mode
  :config
  (progn
    (add-hook 'text-mode-hook 'writegood-mode)))


;; =================================================
;; org-mode
;; =================================================

;; This *might* ignore the bundled version.
;; Or it might not.
;; In any case, I manually installed the latest via
;; package-list-packages
(use-package org
  :ensure t
  :config
  (add-hook 'org-mode-hook 'visual-line-mode)
  (unbind-key "C-;" org-mode-map)
  (unbind-key "C-M-;" org-mode-map)
  ;; (unbind-key "C-'" org-mode-map)
  ;; the following doesn't work.
  ;; :bind (:map org-mode-map
              ;; ("C-'" . ace-window)
              ;; ("C-;" . nil)
              ;; ("C-M-;" . nil)
  ;; )
  (setq org-src-fontify-natively t)
  )
(with-eval-after-load 'org
  (define-key org-mode-map (kbd "C-'") nil))
(global-set-key (kbd "C-c l") 'org-store-link)

;; (org-startup-with-inline-images t)
(org-display-inline-images t)



;; =================================================
;; deft
;; =================================================

(use-package deft
  :ensure t
  :config
  (setq deft-extensions '("org" "md" "txt")
        deft-default-extension "org"
        deft-directory "~/Sync/deft"
        deft-recursive t
        deft-use-filename-as-title t
        deft-use-filter-string-for-filename t
        ;;deft-text-mode 'org-mode
        deft-org-mode-title-prefix t
        deft-file-naming-rules '(
                                 ;;(noslash . "-")
                               (nospace . "-")
                               ;;(case-fn . downcase)
                               )))


;; Courtesy of http://pragmaticemacs.com/emacs/deft-as-a-file-search-tool/
(defun my-deft (dir)
  "run deft in specified dir"
  (setq deft-directory dir)
  (switch-to-buffer "*Deft*")
  (kill-this-buffer)
  (deft))

;; (global-set-key [f8] 'deft)
(global-set-key [f6] (lambda () (interactive) (my-deft "~/Sync/DigitalCrafts")))
(global-set-key [f7] (lambda () (interactive) (my-deft "~/Sync/Journal")))
(global-set-key [f8] (lambda () (interactive) (my-deft "~/Sync/deft")))
(global-set-key [f9] (lambda () (interactive) (my-deft "~/Sync/Learnings")))
(global-set-key [f10] (lambda () (interactive) (my-deft "~/Sync/radishmouse.com/src")))

;; =================================================
;; Blogging
;; =================================================
(require 'ox-publish)
(use-package htmlize
  :ensure t)
(setq org-publish-project-alist
      `(
        ("org"
         :base-directory "~/Sync/radishmouse.com/src"
         :base-extension "org"
         :publishing-directory "~/Sync/radishmouse.com/public"
         :publishing-function org-html-publish-to-html
         :section-numbers nil
         :with-toc nil
         :recursive t
         ;; :html-head ,radishmouse-html-head
         :html-preamble "
<div class='nav'>
<ul>
<li><a href='/'>home</a></li>
<li><a href='/about.html'>about</a></li>
</ul>
</div>
"
         :html-postamble "
<div class='footer'>
Last updated %C. <br>
Built with %c.
   </div>
"
         :html-head-extra "
<link rel=\"stylesheet\" href=\"/stylesheets/normalize.css\">
<link rel=\"stylesheet\" href=\"/stylesheets/index.css\">
"
         :htmlized-source t

         )
        ("static"
         :base-directory "~/Sync/radishmouse.com/src"
         :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf"
         :publishing-directory "~/Sync/radishmouse.com/public"
         :recursive t
         :publishing-function org-publish-attachment
         )
        ("site"
         :components ("org" "static"))
        ))

(defun my-publish-blog-to-html ()
  (interactive)
  (org-publish-project "site"))

(global-set-key (kbd "C-c p") 'my-publish-blog-to-html)


;; =================================================
;; Magit (and version control in general)
;; =================================================

(setq vc-follow-symlinks t)

(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status))
  :config
  (add-hook 'magit-mode-hook (lambda ()
                             (interactive)
                             (undo-tree-mode -1)
                             (buffer-disable-undo)))
  (setq magit-completing-read-function 'ivy-completing-read))
;; (setq magit-mode-hook nil)




;; =================================================
;; Programming mode (general)
;; =================================================

(electric-pair-mode +1)

(setq-default tab-width 2)

;; http://stackoverflow.com/questions/9688748/emacs-comment-uncomment-current-line
(defun comment-or-uncomment-region-or-line ()
    "Comments or uncomments the region or the current line if there's no active region."
    (interactive)
    (let (beg end)
        (if (region-active-p)
            (setq beg (region-beginning) end (region-end))
            (setq beg (line-beginning-position) end (line-end-position)))
        (comment-or-uncomment-region beg end)
        (next-line)))
(global-set-key (kbd "C-,") 'comment-or-uncomment-region-or-line)

(add-hook 'prog-mode-hook 'linum-mode)




;; =================================================
;; Markdown
;; =================================================

(use-package markdown-mode
  :ensure t
  :config
  ;; (unbind-key "<M-up>" markdown-mode-map)
  ;; (unbind-key "<M-down>" markdown-mode-map)
  (add-hook 'markdown-mode-hook 'visual-line-mode))

(use-package olivetti
  :ensure t)

;; spelling

(dolist (hook '(text-mode-hook))
  (add-hook hook (lambda () (flyspell-mode 1))))
(dolist (hook '(markdown-mode-hook))
  (add-hook hook (lambda () (flyspell-mode 1))))

(dolist (hook '(change-log-mode-hook log-edit-mode-hook))
  (add-hook hook (lambda () (flyspell-mode -1))))

(setq-default flyspell-issue-message-flag 'nil
              )
;; (setq ispell-list-command "--list")
(setq ispell-program-name "aspell")


;; =================================================
;; Nix lang
;; =================================================

(use-package nix-mode
  :ensure t
  :config
  )

;; The following was lifted from https://www.reddit.com/r/NixOS/comments/80mg79/how_to_execute_source_blocks_from_within_emacs/
;; As of 2018-03-19... it doesn't work.
(defun nix-shell-context (orig-func &rest args)
  "Set a temporary environment with the correct paths to wrap default 
commands"
  (let* ((nix-path (condition-case nil (nix-exec-path 
                                        (nix-find-sandbox
                                         (or  (file-name-directory (or  buffer-file-name "")) 
"/")))
                     (error nil)))
         (exec-path (or nix-path exec-path)))
    (apply orig-func args)))

;; Functions which need to have their context potentially changed
(advice-add 'executable-find :around #'nix-shell-context)


;; =================================================
;; JavaScript
;; =================================================
(use-package js2-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
  (add-to-list 'js2-mode-hook #'js2-imenu-extras-mode))
(use-package xref-js2
  :ensure t)
(use-package js2-refactor
  :ensure t
  :config
  (add-hook 'js2-mode-hook #'js2-refactor-mode)
  (define-key js2-mode-map (kbd "C-k") #'js2r-kill)
  
  (define-key js2-mode-map (kbd "M-.") nil)
  (add-hook 'js2-mode-hook (lambda ()
  (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t))))
;; (use-package indium
;;   :ensure t
;;   :config)
;; (use-package company-tern
;;   :ensure t
;;   :config
;;   (add-to-list 'company-backends 'company-tern)
;;   (add-hook 'js2-mode-hook (lambda ()
;;                              (tern-mode)
;;                              (company-mode)))
;;   (define-key tern-mode-keymap (kbd "M-.") nil)
;;   (define-key tern-mode-keymap (kbd "M-,") nil)
;;   ;; (define-key esc-map "." #'xref-find-definitions)
;;   )


;; =================================================
;; React/JSX
;; =================================================

(use-package rjsx-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("src\\/.*\\.js\\'" . rjsx-mode))
  )

;; =================================================
;; Emmet mode
;; =================================================

(use-package emmet-mode
  :ensure t
  :config
  (add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
  (add-hook 'css-mode-hook  'emmet-mode) ;; enable Emmet's css abbreviation.
  )


;; =================================================
;; Python
;; =================================================

(use-package elpy
  :ensure t
  :config
  (elpy-enable)
  ;; (setq python-shell-interpreter "ipython"
        ;; python-shell-interpreter-args "-i --simple-prompt")

  (setq python-shell-interpreter "jupyter"
      python-shell-interpreter-args "console --simple-prompt"
      python-shell-prompt-detect-failure-warning nil)
(add-to-list 'python-shell-completion-native-disabled-interpreters
             "jupyter")
  )

(use-package ein
  :ensure t
  :config)

(use-package flycheck
  :ensure t
  :config
  (when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode)))

(use-package py-autopep8
  :ensure t
  :config
  (add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save))

;; ---------------------------------------------------
;; Proce55ing
;; ---------------------------------------------------

(use-package processing-mode
  :ensure t
  :config

  (setq processing-location "/home/radishmouse/Projects/processing-3.5.2/processing-java")
  (setq processing-application-dir "/home/radishmouse/Projects/processing-3.5.2")
  ;; (setq processing-application-dir "/path/to/processing-application-dir")
  (setq processing-sketchbook-dir "/home/radishmouse/Projects/sketchbook")  
  )

;; ---------------------------------------------------
;; Scheme
;; ---------------------------------------------------

;; https://groups.csail.mit.edu/mac/users/gjs/6.945/dont-panic/

;; (use-package xscheme
  ;; :ensure t
  ;; :config

  ;; (setq scheme-root "/usr"
        ;; scheme-program-name (concat
                             ;; scheme-root "/bin/mit-scheme "
                             ;; "--library " scheme-root "/lib/mit-scheme-x86-64 "
                             ;; "--band " scheme-root "/lib/mit-scheme-x86-64/all.com "
                             ;; "-heap 10000"))
  ; :bind
  ;   (define-key scheme-interaction-mode-map (kbd "C-spc") scheme-complete-or-indent)
    ;; )

;; (use-package scheme-complete
  ;; :ensure t
  ;; :config
    ;; (autoload 'scheme-smart-complete "scheme-complete" nil t)
    ;; (autoload 'scheme-get-current-symbol-info "scheme-complete" nil t)
    ;; (setq lisp-indent-function 'scheme-smart-indent-function))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Patch for xscheme - Fixing evaluate-expression in debugger ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (defun xscheme-prompt-for-expression-exit ()
  ;; (interactive)
  ;; (let (
	;; In Emacs 21+, during a minibuffer read the minibuffer
	;; contains the prompt as buffer text and that text is
	;; read only.  So we can no longer assume that (point-min)
	;; is where the user-entered text starts and we must avoid
	;; modifying that prompt text.  The value we want instead
	;; of (point-min) is (minibuffer-prompt-end).
	;; (point-min (if (fboundp 'minibuffer-prompt-end)
		              ;; (minibuffer-prompt-end)
		            ;; (point-min))))
    ;; (if (eq (xscheme-region-expression-p point-min (point-max)) 'one)
        ;; (exit-minibuffer)
      ;; (error "input must be a single, complete expression"))))

(use-package geiser
  :ensure t
  :config
  (setq geiser-active-implementations '(guile))
  (add-hook 'scheme-mode-hook 'geiser-mode))

(use-package paredit
  :ensure t
  :config
  (add-hook 'scheme-mode-hook 'paredit-mode)
  (add-hook 'emacs-lisp-mode-hook 'paredit-mode)
  (add-hook 'clojure-mode-hook 'paredit-mode))


;; ---------------------------------------------------
;; Clojure
;; ---------------------------------------------------
(use-package clojure-mode
  :ensure t
  :config)
(use-package cider
  :ensure t
  :config)


;; =================================================
;; golang
;; =================================================

(defun go-run-buffer ()
  (interactive)
  (shell-command (concat "go run " (buffer-name))))

(use-package go-mode
  :ensure t
  :bind (("C-c C-c" . go-run-buffer))
  :config
  (progn
    (setenv "GOPATH" "/home/radishmouse/src/go")
    (setq gofmt-command "/home/radishmouse/src/go/bin/goimports")
    (add-hook 'before-save-hook 'gofmt-before-save))
  )


;; =================================================
;; Elixir
;; =================================================

(use-package elixir-mode
  :ensure t
  :config

  )

(use-package alchemist :ensure t)

;; =================================================
;; Ruby, rails, etc. mode
;; =================================================

(use-package yaml-mode :ensure t)

;; =================================================
;; Less CSS mode (for angela's squarespace site)
;; =================================================

(use-package less-css-mode
  :ensure t)


;; =================================================
;; Company mode
;; =================================================

(use-package company
  :ensure t
  :bind (("C-." . company-manual-begin)
         ("C-." . company-complete-common)
         ("C-." . company-complete)
         ("C-." . company-select-next)
         :map company-active-map
         ("M-n"   . nil)
         ("M-p"   . nil)
         ("C-n"   . company-select-next)
         ("C-p"   . company-select-previous)
         ("<tab>" . company-complete)
         ("C-c h" . my/company-show-doc-buffer))
  :config
  (setq company-dabbrev-downcase nil
        company-global-modes '(not markdown-mode)
        company-idle-delay 9999999
        )
  (global-set-key (kbd "C-.") 'company-manual-begin)
  (global-set-key (kbd "C-.") 'company-complete-common)
  (global-set-key (kbd "C-.") 'company-complete)
  (global-set-key (kbd "C-.") 'company-select-next)


  (defun enable-company-mode ()
    (company-mode 1))

  (defun my-company-show-doc-buffer ()
    "Temporarily show the documentation buffer for the selection."
    (interactive)
    (let* ((selected (nth company-selection company-candidates))
           (doc-buffer (or (company-call-backend 'doc-buffer selected)
                           (error "No documentation available"))))
      (with-current-buffer doc-buffer
        (goto-char (point-min)))
      (select-window (display-buffer doc-buffer t))))

  (add-hook 'prog-mode-hook 'enable-company-mode)
  (add-hook 'term-mode-hook 'enable-company-mode)

    (use-package company-flx
      :ensure t
      :config
      (company-flx-mode +1)
      ))

;; =================================================
;; image+
;; =================================================

(use-package image+
  :ensure t)


;; =================================================
;; move-text.el - https://www.emacswiki.org/emacs/MoveText
;; =================================================

(defun move-text-internal (arg)
  (cond
   ((and mark-active transient-mark-mode)
    (if (> (point) (mark))
        (exchange-point-and-mark))
    (let ((column (current-column))
          (text (delete-and-extract-region (point) (mark))))
      (forward-line arg)
      (move-to-column column t)
      (set-mark (point))
      (insert text)
      (exchange-point-and-mark)
      (setq deactivate-mark nil)))
   (t
    (let ((column (current-column)))
      (beginning-of-line)
      (when (or (> arg 0) (not (bobp)))
        (forward-line)
        (when (or (< arg 0) (not (eobp)))
          (transpose-lines arg))
        (forward-line -1))
      (move-to-column column t)))))

(defun move-text-down (arg)
  "Move region (transient-mark-mode active) or current line
  arg lines down."
  (interactive "*p")
  (move-text-internal arg))

(defun move-text-up (arg)
  "Move region (transient-mark-mode active) or current line
  arg lines up."
  (interactive "*p")
  (move-text-internal (- arg)))

;; (provide 'move-text)


(global-set-key [M-up] 'move-text-up)
(global-set-key [M-down] 'move-text-down)


(defun create-scratch-buffer nil
  "create a scratch buffer"
  (interactive)
  (switch-to-buffer (get-buffer-create "*scratch*"))
  (insert initial-scratch-message)
  (lisp-interaction-mode))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(css-indent-offset 2)
 '(custom-safe-themes
   (quote
    ("810ab30a73c460f5c49ede85d1b9af3429ff2dff652534518fa1de7adc83d0f6" "aae95fc700f9f7ff70efbc294fc7367376aa9456356ae36ec234751040ed9168" default)))
 '(js-indent-level 2)
 '(org-link-file-path-type (quote relative))
 '(package-selected-packages
   (quote
    (cyberpunk-theme processing-mode htmlize emacs-htmlize ox-publish yafolding company-tern xref-js2 indium cider clojure-mode ein py-autopep8 flycheck emmet-mode ox-hugo org less-css-mode writegood-mode origami olivetti rjsx-mode nix-mode org-mode image+ paredit geiser evil-mode linum-relative evil-leader evil haskell-mode ox-md company-flx yaml-mode alchemist elixir-mode elpy markdown-mode magit deft hydra ace-window undo-tree undohist rainbow-delimiters multiple-cursors which-key counsel ivy naquadah-theme use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'upcase-region 'disabled nil)
