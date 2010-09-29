#lang setup/infotab
(define name "LDAP")
(define release-notes
  (list '(ul (li "Supports authentication"))))
(define repositories
  (list "4.x"))
(define blurb
  (list "A native Racket interface to LDAP"))
(define scribblings '(("ldap.scrbl" (multi-page))))
(define primary-file "main.rkt")
(define categories '(net io))
(define compile-omit-paths
  (list "test.rkt"))