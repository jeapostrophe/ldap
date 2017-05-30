#lang racket/base
(require net/ldap
         tests/eli-tester)

(test
 (ldap-authenticate "ldap.forumsys.com" 389 "uid=tesla,dc=example,dc=com" "password")
 =>
 #t
 
 (ldap-authenticate "ldap.forumsys.com" 389 "uid=tesla,dc=example,dc=com" "password!")
 =>
 #f

 (ldap-authenticate "ldap.forumsys.com" 389 "uid=t3sla,dc=example,dc=com" "password")
 =>
 #f)
