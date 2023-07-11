(setq inhibit-startup-message -1)
(setq-default line-spacing 0.4)
;; this fixes the lag issue on killing emacs, where x-clipboard takes ages to close
(setq x-select-enable-clipboard-manager nil) 
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(tooltip-mode -1)

;; left right padding
(set-fringe-mode 10)

;; disable all graphical pop up, all otherwise i have to click
(setq use-dialog-box nil)

;; Set column numbers in modeline and relative line numbers
(column-number-mode)
 (setq display-line-numbers-type 'relative)
 (global-display-line-numbers-mode t)
  ;; Disable line numbers for some modes
 (dolist (mode '(org-mode-hook
                 term-mode-hook
                 shell-mode-hook
                 eshell-mode-hook))
 (add-hook mode (lambda () (display-line-numbers-mode 0))))

(use-package all-the-icons
 :if (display-graphic-p))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(set-face-attribute 'default nil
                  :font "JetBrainsMono Nerd Font Mono"
                  :height 130
                  :weight 'regular)

(set-face-attribute 'variable-pitch nil
                  :font "Ubuntu Nerd Font"
                  :height 150
                  :weight 'light)

(set-face-attribute 'fixed-pitch nil
                  :font "JetBrainsMono Nerd Font Mono"
                  :height 130
                  :weight 'regular)

(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-one t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  (doom-themes-neotree-config)
  ;; or for treemacs users
  (setq doom-themes-treemacs-theme "doom-one") ; use "doom-colors" for less minimal icon theme
  (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(use-package dashboard
  :ensure t
  :init
  (setq initial-buffer-choice 'dashboard-open)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-banner-logo-title "Happy Hacking!")
  (setq dashboard-startup-banner 'logo) 
  (setq dashboard-center-content t) ;; set to t to center
  (setq dashboard-items '((recents . 10)
                          (agenda . 5)
                          (projects . 5)
                          (bookmarks . 3)
                          ;;(registers . 3)
                          ))
  ;; (dashboard-modify-heading-icons '((recents . "file") (bookmarks . "book")))
  (dashboard-setup-startup-hook))

(setq-default indent-tabs-mode nil) 
;; set history mode for minibuffers
(setq history-length 25)
(savehist-mode 1)

;; keeps recently opened files saved
(recentf-mode 1)

;; if files change outside of emacs, update all buffers AND Dired!
(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t)

;; Move customization variables to separate file, otherwise it will pollute the init.el file.. 
(setq custom-file (locate-user-emacs-file "custom-vars.el"))
(load custom-file 'noerror 'nomessage)

(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                       ("org" . "https://orgmode.org/elpa/")
                       ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
 (unless package-archive-contents
 (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
   (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package swiper)
(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)	
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)))

;; use evil mode EVERYWHERE
(use-package evil
  :init      ;; tweak evil's configuration before loading it
  (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
  (setq evil-want-keybinding nil)
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  (setq evil-want-C-u-scroll t)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :config
  (setq evil-collection-mode-list '(dashboard dired ibuffer magit))
  (evil-collection-init))

;; Esc to quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(use-package general
  :config
  (general-create-definer bp/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (bp/leader-keys
    "." '(project-find-file :which-key "find file in project")
    "f" '(:ignore t :which-key "finds")
    "ff" '(counsel-find-file :which-key "find file")
    "fo" '(counsel-recentf :which-key "find recent (old) file")
    "fr" '(project-find-regexp :which-key "find regexp in project files"))

  (bp/leader-keys
    "b" '(:ignore t :which-key "buffers")
    "bb" '(counsel-ibuffer :which-key "all buffer"))

  (bp/leader-keys
    "p" '(projectile-command-map :which-key "Projectile Key-Map"))

  (bp/leader-keys
    "o" '(:ignore t :which-key "org")
    "oa" '(org-agenda :which-key "agenda")
    "ol" '(org-agenda-list :which-key "agenda week list")
    "os" '(org-schedule :which-key "schedule todo")
    "ot" '(org-todo :which-key "set todo state"))

  (bp/leader-keys
    "n" '(:ignore t :which-key "roam notes")
    "nb" '(org-roam-buffer-toggle :which-key "org roam buffer toggle")
    "nf" '(org-roam-node-find :which-key "find node")
    "ni" '(org-roam-node-insert :which-key "insert node"))

  (bp/leader-keys
    "t" '(:ignore t :which-key "toggles")
    "tt" '(counsel-load-theme :which-key "choose theme")))

(use-package hydra)

(defhydra hydra-text-scale (:timeount 4)
  "scale text"
  ("j" text-scale-increase "inc")
  ("k" text-scale-decrease "dec")
  ("q" nil "quit" :exit t))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.2))

(defun bp/org-mode-setup ()
  (org-indent-mode 1)
  (variable-pitch-mode 1)
  (auto-fill-mode 0)
  (visual-line-mode 1)
  (setq evit-auto-indent nil))

(use-package org
  :hook (org-mode . bp/org-mode-setup)
  :config
  (setq org-ellipsis " ⌄")
  (setq org-agenda-files '("~/Documents/org/TODOs.org"))
  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "ACTIVE(a)" "|" "DONE(d)")
          (sequence "WAIT(w)" "BACKLOG(b)" "PLAN(p)" "IDEA(i)" "REVIEW(r)" "HOLD(h)" "|" "COMPLETED(c)" "CANC(C)")))
  (setq org-refile-targets
        '(("Archive.org" :maxlevel . 1)
          ("TODOs.org" :maxlevel . 1)))
  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer 't)
  (setq org-hide-emphasis-markers t))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("●" "◉" "○" "◉" "○" "◉" "○" "◉")))

(with-eval-after-load 'org-faces
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.0)
                  (org-level-6 . 1.0)
                  (org-level-7 . 1.0)
                  (org-level-8 . 1.0)))
    (set-face-attribute (car face) nil :font "Ubuntu Nerd Font" :weight 'book :height (cdr face))

    ;; Ensure that anything that should be fixed-pitch in Org files appears that way
    (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
    (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
    (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
    (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
    (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
    (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
    (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)))

(defun bp/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . bp/org-mode-visual-fill))

(require 'org-tempo)

(add-to-list 'org-structure-template-alist '("sh" . "src shell"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))

(org-babel-do-load-languages
 'org-bable-loadlanguages
 '((emacs-lisp . t)
   (python . t)))

(defun bp/org-babel-tangle-config ()
 (when (string-equal (buffer-file-name)
  (expand-file-name "~/.emacs.d/Emacs.org"))

  (let ((org-confirm-babel-evaluate nil))
   (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda ()
 (add-hook 'after-save-hook #'bp/org-babel-tangle-config)))

(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory "~/RoamNotes")
  :config
  (org-roam-db-autosync-mode))

(use-package flycheck
  :ensure t
  :defer t
  :diminish
  :init (global-flycheck-mode))

(use-package company
    :defer 2
    :diminish
    :custom
    (company-begin-commands '(self-insert-command))
    (company-idle-delay .1)
    (company-minimum-prefix-length 1)
    (company-show-numbers nil)
    (company-tooltip-align-annotations 't)
    (global-company-mode t))

;;  (use-package company-box
;;    :after company
;;    :diminish
;;    :hook (company-mode . company-box-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :config
  (setq lsp-enable-which-key-integration t))

(use-package lsp-ui)

(use-package lua-mode)
(use-package python-mode)
(use-package web-mode)

(use-package typescript-mode
  :mode ("\\.ts\\'" "\\.js\\'")
  :hook (typescript-mode . lsp-deferred)
  :config
  (setq typescript-indent-level 2))

(use-package smartparens
  :init
  (smartparens-global-mode))

(defun indent-between-pair (&rest _ignored)
  (newline)
  (indent-according-to-mode)
  (forward-line -1)
  (indent-according-to-mode))

(sp-local-pair 'prog-mode "{" nil :post-handlers '((indent-between-pair "RET")))
(sp-local-pair 'prog-mode "[" nil :post-handlers '((indent-between-pair "RET")))
(sp-local-pair 'prog-mode "(" nil :post-handlers '((indent-between-pair "RET")))



(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/Projects")
    (setq projectile-project-search-path '("~/Projects")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(use-package magit)
