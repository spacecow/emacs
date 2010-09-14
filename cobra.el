;; Snippets
(add-to-list 'load-path "~/.emacs.d/vendor/yasnippet-0.6.1c")
(require 'yasnippet)
(yas/initialize)
(yas/load-directory "~/.emacs.d/vendor/yasnippet-0.6.1c/snippets")

;; Color Themes
(add-to-list 'load-path (concat dotfiles-dir "/vendor/color-theme-6.6.0"))
(require 'color-theme)
(color-theme-initialize)
(color-theme-snow)

;; Minor Modes
(add-to-list 'load-path "~/.emacs.d/vendor/textmate.el")
(require 'textmate)
(textmate-mode)

;; Cucumber Mode
(add-to-list 'load-path "~/.emacs.d/elisp/feature-mode/cucumber.el")
(require 'feature-mode)
(add-to-list 'auto-mode-alist '("\.feature$" . feature-mode))

(defun tag-word-or-region (tag)
  "Surround current word or region with a given tag."
  (interactive "sEnter tag (without <>): ")
  (let (pos1 pos2 bds start-tag end-tag)
    (setq start-tag (concat "<" tag ">"))
    (setq end-tag (concat "</" tag ">"))
    (if (and transient-mark-mode mark-active)
        (progn
          (goto-char (region-end))
          (insert end-tag)
          (goto-char (region-beginning))
          (insert start-tag))
      (progn
        (setq bds (bounds-of-thing-at-point 'symbol))
        (goto-char (cdr bds))
        (insert end-tag)
        (goto-char (car bds))
        (insert start-tag)))))

;; Rebind Keys
(global-set-key "\C-z" 'undo)
(global-set-key "\C-xt" 'tag-word-or-region)


;; Set load path for anthy.el
(push "/usr/share/emacs/site-lisp/anthy/" load-path)

;; Load anthy.el
(load-library "leim-list")
(load-library "anthy")

;; Workarounds and customizations

;; Fix slow input response in emacs23
(if (>= emacs-major-version 23)
    (setq anthy-accept-timeout 1))

;; Set japanese-anthy as the default input-method
;; (setq default-input-method "japanese-anthy")

;; Shift-space to toggle anthy-mode (default is Ctrl-\)
;; (global-set-key (kbd "S-SPC") 'anthy-mode)

;; Map wide-space to hankaku-space
;; (setq anthy-wide-space " ")


;; Indent whole buffer
(defun iwb ()
  "indent whole buffer"
  (interactive)
  (delete-trailing-whitespace)
  (indent-region (point-min) (point-max) nil)
  (untabify (point-min) (point-max)))


;; Move line
(defun move-line (n)
  "Move the current line up or down by N lines."
  (interactive "p")
  (setq col (current-column))
  (beginning-of-line) (setq start (point))
  (end-of-line) (forward-char) (setq end (point))
  (let ((line-text (delete-and-extract-region start end)))
    (forward-line n)
    (insert line-text)
    ;; restore point to original column in moved line
    (forward-line -1)
    (forward-char col)))

(defun move-line-up (n)
  "Move the current line up by N lines."
  (interactive "p")
  (move-line (if (null n) -1 (- n))))

(defun move-line-down (n)
  "Move the current line down by N lines."
  (interactive "p")
  (move-line (if (null n) 1 n)))

(global-set-key (kbd "M-<up>") 'move-line-up)
(global-set-key (kbd "M-<down>") 'move-line-down)


;; Move region
(defun move-region (start end n)
  "Move the current region up or down by N lines."
  (interactive "r\np")
  (let ((line-text (delete-and-extract-region start end)))
    (forward-line n)
    (let ((start (point)))
      (insert line-text)
      (setq deactivate-mark nil)
      (set-mark start))))

(defun move-region-up (start end n)
  "Move the current line up by N lines."
  (interactive "r\np")
  (move-region start end (if (null n) -1 (- n))))

(defun move-region-down (start end n)
  "Move the current line down by N lines."
  (interactive "r\np")
  (move-region start end (if (null n) 1 n)))

(global-set-key (kbd "M-S-<up>") 'move-region-up)
(global-set-key (kbd "M-S-<down>") 'move-region-down)
