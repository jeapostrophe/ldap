#lang racket
#| Non-robust LDAP based on

http://tools.ietf.org/html/rfc4511

http://en.wikipedia.org/wiki/Basic_Encoding_Rules

https://www.opends.org/wiki/page/DefBasicEncodingRules

|#
(require unstable/contract)

(struct ldap (to from))

(provide/contract
 #;[ldap-connect (string? port-number? . -> . ldap?)]
 #;[ldap-bind (ldap? string? string? . -> . boolean?)]
 [ldap-authenticate (string? port-number? string? string? . -> . boolean?)]
 #;[ldap-close! (ldap? . -> . void)])

(define (ldap-connect server port)
  (define-values (from-ldap to-ldap) (tcp-connect server port))
  (ldap to-ldap from-ldap))

(define (*read-byte p)
  (define v (read-byte p))
  (when (eof-object? v)
    (error 'read-byte "Connection unexpectedly closed"))
  v)

(define (ldap-bind l rdn p)
  (match-define (ldap to from) l)
  (write-bytes (bind-request rdn p) to)
  (flush-output to)
  (define seq-tag (*read-byte from))
  (define seq-len (*read-byte from))
  (define msg-tag (*read-byte from))
  (define msg-len (*read-byte from))
  (define msg (*read-byte from))
  (unless (zero? msg)
    (error 'ldap-bind "Expected response to msg 0, but got a response to msg ~a" msg))
  (define bs-tag (*read-byte from))
  (define bs-len (*read-byte from))
  (define ld-tag (*read-byte from))
  (define ld-len (*read-byte from))
  (define enum-tag (*read-byte from))
  (define enum-len (*read-byte from))
  (define enum (*read-byte from))
  (zero? enum))

(define (ldap-close! l)
  (match-define (ldap to from) l)
  (close-output-port to)
  (close-input-port from))

(define (bind-request rdn p)
  (define rdn-bs (string->bytes/utf-8 rdn))
  (define p-bs (string->bytes/utf-8 p))
  (define rdn-len (bytes-length rdn-bs))
  (define p-len (bytes-length p-bs))
  (define len
    (+ 3 1 1 rdn-len 1 1 p-len))
  (bytes-append
   (bytes #b00110000 (+ 5 len)
          #x2 #x1 #x0)
   (bytes #x60 len
          #x2 #x1 #x3
          #x4 rdn-len)
   rdn-bs
   (bytes #x80 p-len)
   p-bs))

#;(require file/sha1 tests/eli-tester)
#;(test (bytes->hex-string (bind-request "cn=test" "password"))
        =>
        "301b02010060160201030407636e3d74657374800870617373776f7264")

(define (ldap-authenticate server port rdn passwd)
  (define db (ldap-connect server port))
  (begin0 (ldap-bind db rdn passwd)
          (ldap-close! db)))