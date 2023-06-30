;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "David Nusinow"
      user-mail-address "dnusinow@interlinetx.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-tomorrow-day)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Maximize the frame on startup
(add-hook 'window-setup-hook #'toggle-frame-maximized)

;; I like the GUI
(tool-bar-mode 1)
(menu-bar-mode 1)
(scroll-bar-mode 1)
(load-theme 'tango t)

(require 'evil-visual-mark-mode)
(evil-visual-mark-mode 1)

(require 'rainbow-delimiters)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;; Key bindings
(map! :leader
      :desc "Occur"
      "b o" #'occur)

;; Windmove allows quick changes between windows using shift-arrows by default
(require 'windmove)
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

(global-undo-tree-mode)

;; ESS
(require 'ess-site)
(setq ess-style 'RRR)
;; C-c C-= instead
;; (define-key ess-r-mode-map "_" #'ess-insert-assign)
;; (define-key inferior-ess-r-mode-map "_" #'ess-insert-assign)

(define-key inferior-ess-mode-map (kbd "M-/") 'dabbrev-expand)

(defun ess---buffer-or-project-dir ()
  "Return directory for current buffer's visited file. If no
visited file then return the project directory"
  (let ((dir (cond ((buffer-file-name)
                    (file-name-directory (buffer-file-name)))
                   (t default-directory))))
    dir))

(setq ess-startup-directory-function 'ess---buffer-or-project-dir)


(use-package erasciible-mode
  :load-path "/Users/davidnusinow/src/erasciible-mode")

(defun my-ess-hook ()
  (define-key ess-mode-map (kbd "M-/") 'dabbrev-expand)
  (define-key ess-mode-map "\t" 'company-complete-common)
  (subword-mode)
  (company-mode)
  (undo-tree-mode)
  (copilot-mode -1))

(eval-after-load "ess-mode"
  '(add-hook 'ess-mode-hook 'my-ess-hook))

(eval-after-load "ess-mode"
  '(add-hook 'ess-mode-hook 'my-ess-hook))

;; (eval-after-load "ess-mode"
;;   '(add-hook 'ess-mode-hook
;;              '(lambda ()
;;                 (define-key ess-mode-map (kbd "M-/") 'dabbrev-expand)
;;                 (define-key ess-mode-map "\t" 'company-complete-common)
;;                 (subword-mode)
;;                 (company-mode)
;;                 (copilot-mode -1))))

;; (eval-after-load "inferior-ess-mode"
;;   '(add-hook 'inferior-ess-mode-hook
;;              '(lambda ()
;;                 (define-key inferior-ess-mode-map (kbd "M-/") 'dabbrev-expand)
;;                 (define-key inferior-ess-mode-map "\t" 'company-complete-common)
;;                 (subword-mode)
;;                 (company-mode)
;;                 (copilot-mode -1))))

(add-to-list 'auto-mode-alist '("\\.Rasciidoc$" . adoc-mode))
(add-to-list 'auto-mode-alist '("\\.asciidoc$" . adoc-mode))

;; (add-to-list 'auto-mode-alist '("\\.Rmd$" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))

(add-to-list 'auto-mode-alist '("\\.Rmd" . poly-markdown-mode))

(eval-after-load "adoc-mode"
  '(add-hook 'adoc-mode-hook
			 '(lambda ()
			    (company-mode))))

;; Quarto
(require 'quarto-mode)

(define-derived-mode ojs-mode
  js2-mode "Observable JS")

;;; Web
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.php$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?$" . web-mode))

;;; SQL
(eval-after-load "sql"
  (load-library "sql-indent"))

(defun sqlformat-buffer ()
  "Run sqlformat on the current buffer."
  (interactive)
  (save-excursion
    (mark-whole-buffer)
    (shell-command-on-region (point) (mark) "sqlformat -r -" nil t)))


;; (require 'sparql-mode)
(add-to-list 'auto-mode-alist '("\\.rq$" . sparql-mode))
(add-to-list 'auto-mode-alist '("\\.rql$" . sparql-mode))

;; Org

(require 'company-org-roam)
    (use-package company-org-roam
      :when (featurep! :completion company)
      :after org-roam
      :config
      (set-company-backend! 'org-mode '(company-org-roam company-yasnippet company-dabbrev)))

(setq org-roam-graph-executable "/usr/local/bin/dot")

(use-package deft
      :after org
      :bind
      ("C-c n d" . deft)
      :custom
      (deft-recursive t)
      (deft-use-filter-string-for-filename t)
      (deft-default-extension "org")
      (deft-directory "~/org/roam"))

;; Python

(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "-i --simple-prompt --InteractiveShell.display_page=True")

;; Copilot
;; accept completion from copilot and fallback to company
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (("C-TAB" . 'copilot-accept-completion-by-word)
         ("C-<tab>" . 'copilot-accept-completion-by-word)
         :map copilot-completion-map
         ("<tab>" . 'copilot-accept-completion)
         ("TAB" . 'copilot-accept-completion)))

;; Markup faces

(use-package adoc-mode)

;; (dolist (elt '(markup-anchor-face
;;                markup-attribute-face
;;                markup-command-face
;;                markup-comment-face
;;                markup-internal-reference-face
;;                markup-meta-face
;;                markup-meta-hide-face))
;;   (set-face-attribute elt nil :height 1.0 :foreground "dim gray"))

;; (dolist (elt '(markup-secondary-text-face
;;                markup-small-face
;;                markup-subscript-face
;;                markup-superscript-face
;;                markup-table-cell-face
;;                markup-table-face
;;                markup-table-row-face
;;                markup-typewriter-face
;;                markup-value-face))
;;   (set-face-attribute elt nil :height 1.2))

;; (set-face-attribute 'markup-comment-face nil
;;                     :foreground "royal blue"
;;                     :background "pale goldenrod")


;; Utility Functions

(defun quote-and-comma-lines ()
  "Quote each selected line and append commas to all but the last line"
  (interactive)
  (save-excursion
    (let* ((start (car (evil-visual-range)))
           (end (car (cdr (evil-visual-range))))
           (extra-chars (* 3 (count-lines-region start end))))
      (goto-char start)
      (move-beginning-of-line 1)
      (while (<= (point) (- (+ extra-chars end) 1))
        (insert "\"")
        (move-end-of-line 1)
        (insert "\",")
        (move-beginning-of-line 2))
      (move-beginning-of-line 1)
      (backward-char 1)
      (delete-char -1))))

;; Written by chat gpt
(defun add-quotes-and-commas-to-region (start end)
  "Put double quotes around each line in the region and append a comma to all but the last line."
  (interactive "r")
  (save-excursion
    (goto-char start)
    (while (< (point) end)
      (beginning-of-line)
      (insert "\"")
      (end-of-line)
      (insert "\",")
      (forward-line)))
  ;; Remove the trailing comma from the last line
  (save-excursion
    (goto-char (- end 2))
    (delete-char 1)))
