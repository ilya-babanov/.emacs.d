;; init.el --- description -*- lexical-binding: t; -*-
;;; Commentary:
;;; Hello there!
;;; Code:

(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives '(("org"   . "http://orgmode.org/elpa/")
                         ("gnu"   . "http://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))

(unless package--initialized (package-initialize))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(load "~/.emacs.d/custom/funcs.el")

(add-to-list 'default-frame-alist '(font . "Hack-12"))
(add-to-list 'default-frame-alist '(height . 40))
(add-to-list 'default-frame-alist '(width . 80))

(when window-system
  (scroll-bar-mode 0)
  (tool-bar-mode 0)
  (tooltip-mode 0)
  (menu-bar-mode 0))

(setq-default
 ad-redefinition-action 'accept
 auto-window-vscroll nil
 cursor-in-non-selected-windows t
 delete-by-moving-to-trash t
 display-time-default-load-average nil
 display-time-format "%H:%M"
 fill-column 80
 help-window-select t
 indent-tabs-mode nil
 inhibit-startup-screen t
 initial-scratch-message ""
 initial-buffer-choice nil
 initial-major-mode 'fundamental-mode
 create-lockfiles nil
 mouse-yank-at-point t
 recenter-positions '(5 top bottom)
 scroll-conservatively most-positive-fixnum
 scroll-margin 10
 select-enable-clipboard t
 sentence-end-double-space nil
 show-trailing-whitespace nil
 split-height-threshold nil
 split-width-threshold nil
 tab-width 4
 uniquify-buffer-name-style 'forward
 window-combination-resize t
 enable-dir-local-variables nil
 enable-local-variables :safe
 x-stretch-cursor t)

(global-auto-revert-mode 1)
(show-paren-mode 1)
(delete-selection-mode 1)
(fset 'yes-or-no-p 'y-or-n-p)
(mouse-avoidance-mode 'banish)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(set-default-coding-systems 'utf-8)

(add-hook 'prog-mode-hook (lambda () (setq show-trailing-whitespace t)))

(use-package exec-path-from-shell
  :config
  (setq exec-path-from-shell-arguments '("-l" "-i"))
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

(use-package all-the-icons)

(use-package doom-themes
  :config
  (load-theme 'doom-solarized-light t)
  (doom-themes-neotree-config))

(use-package solaire-mode
  :hook ((change-major-mode after-revert ediff-prepare-buffer) . turn-on-solaire-mode)
  :config
  (add-hook 'minibuffer-setup-hook #'solaire-mode-in-minibuffer))

(use-package doom-modeline
  :hook (after-init . doom-modeline-init)
  :init
  (setq doom-modeline-major-mode-icon nil)
  (setq doom-modeline-persp-name nil)
  (setq doom-modeline-buffer-file-name-style 'file-name))

(use-package dashboard
  :config
  (setq dashboard-items '((recents  . 10)
                          (projects . 5)
                          (bookmarks . 5)))
  (dashboard-setup-startup-hook))

(use-package evil
  :init
  (setq evil-want-C-u-scroll t
        evil-want-visual-char-semi-exclusive t
        evil-respect-visual-line-mode t
        evil-search-module 'evil-search
        evil-symbol-word-search t)
  :config
  (evil-mode 1))

(use-package evil-magit)

(use-package expand-region)

(use-package anzu
  :config
  (global-anzu-mode 1)
  (global-set-key [remap query-replace-regexp] 'anzu-query-replace-regexp)
  (global-set-key [remap query-replace] 'anzu-query-replace))

(use-package evil-anzu)

(use-package helm
  :init
  (setq
   helm-default-display-buffer-functions '(display-buffer-in-side-window)
   helm-always-two-windows nil
   helm-ff-fuzzy-matching nil
   helm-M-x-fuzzy-match t
   helm-buffers-fuzzy-matching t
   helm-recentf-fuzzy-match t
   helm-completion-in-region-fuzzy-match t
   helm-candidate-number-list 80
   helm-split-window-in-side-p t
   helm-move-to-line-cycle-in-source nil
   helm-echo-input-in-header-line t
   helm-autoresize-max-height 0
   helm-autoresize-min-height 20)
  :config
  (helm-mode 1))

(use-package helm-ag
  :config
  (setq helm-ag-base-command "rg --smart-case --no-heading --line-number --max-columns 150"))

(use-package projectile
  :init
  (setq projectile-require-project-root nil)
  (setq projectile-enable-caching t)
  :config
  (projectile-mode 1))

(use-package helm-projectile
  :init
  (setq helm-projectile-fuzzy-match nil)
  :config
  (helm-projectile-on))

(use-package flycheck
  :config
  (global-flycheck-mode))

(use-package neotree
  :init
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow)))

(use-package evil-nerd-commenter
  :commands (evilnc-comment-or-uncomment-lines))

(use-package buttercup)

(use-package bpr
  :commands (bpr-spawn bpr-open-last-buffer)
  :config
  (setq bpr-colorize-output t)
  (setq bpr-on-start 'p-bpr-set-comint-filter))

(use-package magit
  :init
  (setq magit-refresh-status-buffer nil))

(use-package git-gutter
  :hook (prog-mode . git-gutter-mode))

(use-package shackle
  :config
  (setq shackle-rules
        '((neotree-mode :align left)
          ("\\*helm.*?\\*" :regexp t :align t :size 0.5)
          ("\\*term:.*?\\*" :regexp t :align t :select t :size 0.6)
          ("\\*.*\\*" :regexp t :align t :select t :size 0.5)))
  (shackle-mode))

(use-package emmet-mode
  :hook (css-mode html-mode rjsx-mode web-mode)
  :config
  (setq
   emmet-insert-flash-time .1
   emmet-move-cursor-between-quote t))

(use-package yasnippet
  :hook (prog-mode . yas-minor-mode)
  :config
  (setq yas-snippet-dirs `(,(expand-file-name "snippets/" user-emacs-directory)))
  (yas-reload-all))

(use-package editorconfig
  :config
  (editorconfig-mode))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package electric
  :hook (prog-mode . electric-indent-mode))

(use-package elec-pair
  :hook (prog-mode . electric-pair-mode))

(use-package files
  :ensure nil
  :config
  (setq-default
   backup-by-copying t
   backup-directory-alist `(("." . ,(expand-file-name "backups/" user-emacs-directory)))
   delete-old-versions t
   version-control t))

(use-package lsp-mode
  :init
  (add-hook 'prog-major-mode #'lsp-prog-major-mode-enable))

;;(use-package lsp-ui
;;  :init
;;  (add-hook 'lsp-mode-hook 'lsp-ui-mode))

(use-package company
  :init
  (setq company-minimum-prefix-length 3)
  (setq company-idle-delay 0)
  (setq company-require-match 'never)
  (setq tab-always-indent 'complete)
  :config
  (global-company-mode 1)
  (define-key company-active-map (kbd "TAB") 'company-complete-common-or-cycle)
  (define-key company-active-map (kbd "<tab>") 'company-complete-common-or-cycle)
  (define-key company-active-map (kbd "S-TAB") 'company-select-previous)
  (define-key company-active-map (kbd "<backtab>") 'company-select-previous))

(use-package company-quickhelp
  :config
  (setq company-quickhelp-delay nil)
  (company-quickhelp-mode))

(use-package company-lsp
  :commands (company-lsp)
  :init
  (setq company-lsp-async t)
  (push #'company-lsp company-backends))

(use-package js2-mode
  :mode "\\.js\\'"
  :config
  (setq
   js2-idle-timer-delay 0
   js2-strict-trailing-comma-warning nil
   js2-strict-missing-semi-warning nil
   js2-mode-show-parse-errors nil
   js2-mode-show-strict-warnings nil))

(use-package json-mode
  :mode "\\.json\\'")

(use-package rjsx-mode
  :mode "\\.jsx\\'")

(use-package typescript-mode
  :mode "\\.ts\\'")

(use-package lsp-javascript-typescript
  :hook ((js-mode typescript-mode) . lsp-javascript-typescript-enable))

(use-package rust-mode
  :mode "\\.rs\\'")

(use-package lsp-rust
  :hook (rust-mode . lsp-rust-enable)
  :init
  (setq lsp-rust-rls-command '("rustup" "run" "nightly" "rls")))

(use-package csv-mode
  :mode "\\.csv\\'")

(use-package dockerfile-mode
  :mode "Dockerfile\\'")

(use-package yaml-mode
  :mode "\\.ya?ml\\'")

(use-package web-mode
  :mode ("\\.erb\\'" "\\.mustache\\'" "\\.vue\\'" "\\.html?\\'" "\\.php\\'" "\\.inc\\'" "\\.tmpl\\'"))

(use-package go-mode
  :mode "\\.go\\'")

(use-package lsp-java
  :hook (java-mode . lsp-java-enable)
  :init
  (setq lsp-java-save-action-organize-imports nil)
  (setq lsp-inhibit-message t))

(use-package which-key
  :init
  (setq which-key-separator " ")
  (setq which-key-prefix-prefix "+")
  :config
  (which-key-mode))

(use-package general
  :config
  (general-define-key
   "<escape>" '(p-quit :which-key "escape")
   "<f4>" '(p-term-in-project :which-key "terminal in project"))

  (general-define-key
   :states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "M-SPC"

   "SPC" '(helm-M-x :which-key "M-x")
   "TAB" '(switch-to-prev-buffer :which-key "previous buffer")
   "RET" '(helm-bookmarks :which-key "bookmark")
   "/"   '(helm-do-ag-project-root :which-key "search in project")
   "a"   '(helm-mini :which-key "buffers list")
   ";"   '(evilnc-comment-or-uncomment-lines :which-key "comment")
   "."   '(helm-find-files :which-key "find files")

   "bk"  '(kill-this-buffer :which-key "kill this buffer")

   "cd"  '(xref-find-definitions :which-key "go to definition")
   "ci"  '(lsp-goto-implementation :which-key "go to implementation")
   "ce"  '(flycheck-list-errors :which-key "list errors")

   "ff"  '(helm-projectile-find-file :which-key "find files")
   "fp"  '(helm-projectile-find-file :which-key "find files in project")
   "fy"  '(p-copy-file-name-and-line-number :which-key "copy file name and line number")

   "gg"  '(magit :which-key "magit")
   "gb"  '(magit-blame :which-key "git blame")
   "gl"  '(magit-log-buffer-file :which-key "log current file")
   "gm"  '(p-shell-show-mine-commits :which-key "show mine commits")

   "ot"  '(p-term :which-key "open terminal")
   "on"  '(neotree-toggle :which-key "toggle neotree")

   "pf"  '(helm-projectile-find-file :which-key "find files in project")
   "pp"  '(helm-projectile-switch-project :which-key "switch project")
   "pb"  '(helm-projectile-switch-to-buffer :which-key "switch buffer")

   "tn"  '(neotree-toggle :which-key "toggle neotree")
   "tl"  '(toggle-truncate-lines :which-key "toggle line wrapping")

   "qz"  '(delete-frame :which-key "delete frame")
   "qq"  '(kill-emacs :which-key "quit")

   "hh"  '(helm-apropos :which-key "apropos")
   "jk"  '(helm-show-kill-ring :which-key "show kill ring")
   "jh"  '(helm-resume :which-key "helm-resume")
   "js"  '(p-boo-sync :which-key "boo sync")
   "jr"  '(p-boo-sync-restart :which-key "boo sync and restart")
   "jb"  '(p-boo-set-role :which-key "boo set role")
   "jl"  '(bpr-open-last-buffer :which-key "boo set role")
   "ji"  '(comint-clear-buffer :which-key "clear comint buffer")

   "wl"  '(windmove-right :which-key "move right")
   "wh"  '(windmove-left :which-key "move left")
   "wk"  '(windmove-up :which-key "move up")
   "wj"  '(windmove-down :which-key "move bottom")
   "wL"  '(evil-window-move-far-right :which-key "move window right")
   "wH"  '(evil-window-move-far-left :which-key "move window left")
   "wK"  '(evil-window-move-very-top :which-key "move window up")
   "wJ"  '(evil-window-move-very-bottom :which-key "move window bottom")
   "wv"  '(split-window-right :which-key "split right")
   "ws"  '(split-window-below :which-key "split bottom")
   "wc"  '(delete-window :which-key "delete window"))

  (general-define-key
   :keymaps 'evil-normal-state-map
   "<escape>" '(p-quit :which-key "escape"))

  (general-define-key
   :keymaps 'helm-map
   "C-v" '(clipboard-yank :which-key "paste"))

  (general-define-key
   :keymaps 'helm-ag-map
   "C-t" '(p-insert-g-arg :which-key "insert rg argument"))

  (general-define-key
   :keymaps 'neotree-mode-map
   :states 'normal
   "TAB" 'neotree-quick-look
   "RET" 'neotree-enter
   "c"   'neotree-create-node
   "r"   'neotree-rename-node
   "d"   'neotree-delete-node
   "j"   'neotree-next-line
   "k"   'neotree-previous-line
   "n"   'neotree-next-line
   "p"   'neotree-previous-line
   "J"   'neotree-select-next-sibling-node
   "K"   'neotree-select-previous-sibling-node
   "H"   'neotree-select-up-node
   "L"   'neotree-select-down-node
   "v"   'neotree-enter-vertical-split
   "s"   'neotree-enter-horizontal-split
   "q"   'neotree-hide
   "R"   'neotree-refresh)

  (general-define-key
   :keymaps 'evil-visual-state-map
   "v" '(er/expand-region :which-key "expand region")
   "V" '(er/contract-region :which-key "contract region"))

  (general-define-key
   :keymaps 'company-active-map
   "C-i" '(company-quickhelp-manual-begin :which-key "show docs"))

  (general-define-key
   :keymaps 'company-search-map
   "C-n" '(company-search-repeat-forward :which-key "next")
   "C-p" '(company-search-repeat-backward :which-key "previous")))

(setq custom-file (expand-file-name ".custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

(provide 'init)

;;; init.el ends here
