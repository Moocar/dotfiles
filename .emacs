;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
(when
    (load
     (expand-file-name "~/.emacs.d/elpa/package.el"))
  (package-initialize))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Locally-installed packages (non-ELPA)

(push "~/.emacs.d/local/" load-path)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Customizations

(when (fboundp 'tabbar-mode) (tabbar-mode -1))

;; for compatibility with older Aquamacs versions
 (defvar aquamacs-140-custom-file-upgraded t)
 (unless (fboundp 'auto-detect-longlines) (defun auto-detect-longlines () t))

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(aquamacs-additional-fontsets nil t)
 '(aquamacs-autoface-mode nil)
 '(aquamacs-customization-version-id 208 t)
 '(aquamacs-tool-bar-user-customization (quote ((16777249 new-file open-file recent-files save-buffer aquamacs-print nil undo redo cut copy paste isearch-forward nil customize help))) t)
 '(backward-delete-char-untabify-method (quote all))
 '(global-auto-revert-mode t)
 '(global-linum-mode t)
 '(indent-tabs-mode nil)
 '(linum-format "%3d ")
 '(ns-tool-bar-display-mode (quote both) t)
 '(ns-tool-bar-size-mode (quote regular) t)
 '(org-special-ctrl-a/e t)
 '(org-startup-folded (quote showeverything))
 '(org-todo-keywords (quote ((sequence "TODO" "INPROGRESS" "DONE"))))
 '(safe-local-variable-values (quote ((eval define-clojure-indent (to-data (quote defun))))))
 '(slime-kill-without-query-p t)
 '(slime-net-coding-system (quote utf-8-unix))
 '(slime-truncate-lines nil)
 '(tool-bar-mode nil)
 '(uniquify-buffer-name-style (quote forward) nil (uniquify))
 '(visual-line-mode nil t))

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:stipple nil :background "#141414" :foreground "#CACACA" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 200 :width normal :family "Anonymous Pro"))))
 '(linum ((t (:inherit (shadow default) :background "black" :foreground "#444"))))
 '(magit-diff-add ((((class color) (background dark)) (:foreground "green"))))
 '(mode-line-inactive ((t (:inherit aquamacs-variable-width :background "grey10" :foreground "grey40" :box (:line-width -1 :color "grey20") :strike-through nil :underline nil :slant normal :weight normal :width normal))))
 '(org-hide ((((background dark)) (:foreground "#141414"))))
 '(outline-4 ((t (:foreground "#8F8A80")))))

(put 'narrow-to-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'erase-buffer 'disabled nil)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Magit
;; http://github.com/philjackson/magit/downloads

(autoload 'magit-status "magit" nil t)
(global-set-key (kbd "C-x m") 'magit-status)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CLOJURE/SWANK/SLIME

(autoload 'clojure-mode "clojure-mode" nil t)

(eval-after-load 'clojure-mode
  '(progn
     (require 'paredit)
     (defun clojure-paredit-hook () (paredit-mode +1))
     (add-hook 'clojure-mode-hook 'clojure-paredit-hook)
     
     (define-key clojure-mode-map "{" 'paredit-open-brace)
     (define-key clojure-mode-map "}" 'paredit-close-brace)

     ;; Custom indentation rules; see clojure-indent-function
     (define-clojure-indent
       (describe 'defun)
       (testing 'defun)
       (given 'defun)
       (using 'defun)
       (with 'defun)
       (it 'defun)
       (do-it 'defun))))

(eval-after-load 'slime
  '(setq slime-protocol-version 'ignore))

(require 'elein)

(defun clojure-repl ()
  (interactive)
  (inferior-lisp "java -jar /Users/stuart/src/clojure/clojure/target/clojure-1.3.0-master-SNAPSHOT.jar"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FILE ASSOCIATIONS

(add-to-list 'auto-mode-alist '("\\.\\(rdfs?\\|owl\\)$" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.st$" . fundamental-mode))
(add-to-list 'auto-mode-alist '("\\.clj$" . clojure-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LINUX-STYLE C CODE

(defun linux-c-mode ()
  "C mode with adjusted defaults for use with the Linux kernel."
  (interactive)
  (c-mode)
  (c-set-style "K&R")
  (setq c-basic-offset 8))

(setq auto-mode-alist (cons '("/usr/src/linux.*/.*\\.[ch]$" . linux-c-mode)
                       auto-mode-alist))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; IDO
;; http://www.emacswiki.org/emacs/InteractivelyDoThings

(require 'ido)
(ido-mode t)
(setq ido-enable-flex-matching t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SMEX
;; http://github.com/nonsequitur/smex/

(require 'smex)
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org-mode and Day Pages
;; http://almostobsolete.net/daypage.html

(add-hook 'org-mode-hook 'set-word-wrap)

(setq daypage-path "~/Documents/daypage/")

(defun find-daypage (&optional date)
  "Go to the day page for the specified date, 
   or toady's if none is specified."
  (interactive (list 
                (org-read-date "" 'totime nil nil
                               (current-time) "")))
  (setq date (or date (current-time)))
  (find-file 
       (expand-file-name 
        (concat daypage-path 
        (format-time-string "daypage-%Y-%m-%d-%a" date) ".org")))
  (when (= 0 (buffer-size))
        ;; Insert an initial for the page
        (insert (format-time-string "* %Y-%m-%d %A : " date))))

(defun todays-daypage ()
  "Go straight to today's day page without prompting for a date."
  (interactive) 
  (find-daypage))

(global-set-key "\C-con" 'todays-daypage)
(global-set-key "\C-coN" 'find-daypage)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; zap-up-to-char

(defun zap-up-to-char (arg char)
  "Kill up to but not including ARGth occurrence of CHAR.
Case is ignored if `case-fold-search' is non-nil in the current buffer.
Goes backward if ARG is negative; error if CHAR not found."
  (interactive "p\ncZap up to char: ")
  ;; Avoid "obsolete" warnings for translation-table-for-input.
  (with-no-warnings
    (if (char-table-p translation-table-for-input)
	(setq char (or (aref translation-table-for-input char) char))))
  (kill-region (point) (progn
			 (search-forward (char-to-string char) nil nil arg)
;			 (goto-char (if (> arg 0) (1- (point)) (1+ (point))))
			 (1- (point))))
  (goto-char (1- (point))))

(global-unset-key "\M-z")
(global-set-key "\M-z" 'zap-up-to-char)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; "Twilight" color theme

(when (window-system)
  (load-library "color-theme-twilight")
  (add-hook 'after-init-hook 'color-theme-twilight))
