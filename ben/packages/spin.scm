(define-module (ben packages spin)
  #:use-module (gnu packages)
  #:use-module (guix git-download)
  #:use-module (guix licenses)
  #:use-module (guix packages)
  #:use-module (guix build-system gnu)
  #:use-module (guix download)
  #:use-module (gnu packages bison)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages base))

(define-public spin
  (package
   (name "spin")
   (version "6.5.2")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
           (url "https://github.com/nimble-code/Spin")
           (commit (string-append "version-" version))))
     (file-name (git-file-name name version))
     (sha256
      (base32 "0mf8bisl27dysnfhy9nmhnrk6bw3cx9zsv8nf1r982fry1fx1fvn"))))
   (build-system gnu-build-system)
   (arguments
    `(#:make-flags (list "CC=gcc")
      #:phases
      (modify-phases %standard-phases
                     (delete 'configure)
                     (delete 'check)
                     ;; (delete 'install)
                     (replace 'install
                              (lambda* (#:key inputs outputs #:allow-other-keys)
                                (let ((out (assoc-ref outputs "out")))
                                  (invoke "make" "INSTALL=install -D" (string-append "DESTDIR=" out) "install")))))))
   (inputs
    `(("gcc" ,gcc)
      ("glibc" ,glibc)))
   (native-inputs
    `(("bison" ,bison)))
   (home-page "http://spinroot.com/spin/whatispin.html")
   (synopsis "Formal software verification tool")
   (description
    "Spin is a widely used open-source software verification tool. The tool can be used for the formal verification of multi-threaded software applications. The tool was developed at Bell Labs in the Unix group of the Computing Sciences Research Center, starting in 1980, and has been available freely since 1991. Spin continues to evolve to keep pace with new developments in the field. In April 2002 the tool was awarded the ACM System Software Award")
   (license bsd-3)))
