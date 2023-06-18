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

;; set up fonts 
(set-face-attribute 'default nil
                  :font "UbuntuMono Nerd Font Mono"
                  :height 160
                  :weight 'regular)

(set-face-attribute 'variable-pitch nil
                  :font "Ubuntu Nerd Font"
                  :height 160
                  :weight 'light)

(set-face-attribute 'fixed-pitch nil
                  :font "UbuntuMono Nerd Font Mono"
                  :height 160
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
	 ("C-x C-f" . counsel-find-file)
	 :map minibuffer-local-map
	 ("C-r" . counsel-minibuffer-history)))

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
   "bb" '(counsel-ibuffer :which-key "all buffers"))

  (bp/leader-keys
   "p" '(projectile-command-map :which-key "Projectile Key-Map"))

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

(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill))

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
