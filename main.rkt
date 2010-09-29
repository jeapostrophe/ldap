#lang racket
(require unstable/contract)

(struct ldap ())

(provide/contract
 [ldap-connect (string? port-number? . -> . ldap?)]
 [ldap-bind (ldap? string? string? . -> . boolean?)])

(define (ldap-connect server port)
  (ldap))

(define (ldap-bind l rdn p)
  #f)