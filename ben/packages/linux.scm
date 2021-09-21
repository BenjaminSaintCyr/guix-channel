(define-module (ben packages linux)
  #:use-module (gnu packages)
  #:use-module (guix git-download)
  #:use-module (guix licenses)
  #:use-module (guix packages)
  #:use-module (guix build-system gnu)
  #:use-module (guix download)
  #:use-module (gnu packages bison)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages base)
  #:use-module (gnu packages datastructures)
  #:use-module (gnu packages popt)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages flex)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages linux)
  ;; doc option
  ;; #:use-module (gnu packages documentation)
  )

(define-public lttng-tools
  (package
   (name "lttng-tools")
   (version "2.12.2")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/lttng/lttng-tools")
                  (commit (string-append "v" version))))
            (sha256
             (base32
              "1pwicvj01qwdcgkqx03m1w89js1chxaxsqpijzh39k0ddml7lka5"))))
   (build-system gnu-build-system)
   (arguments
    `(#:tests? #f
      #:configure-flags '("--disable-man-pages")
      #:phases (modify-phases %standard-phases
                              (add-before 'configure 'bootstrap
                                          (lambda* (#:key inputs outputs #:allow-other-keys)
                                            (invoke "./bootstrap")))
                              ;; (add-after 'install 'ldconfig
                              ;;            (lambda* (#:key inputs outputs #:allow-other-keys)
                              ;;              (invoke "ldconfig")))
                              )))
   (inputs
    `(("lttng-ust" ,lttng-ust)
      ("liburcu" ,liburcu)
      ;; ("numactl" ,numactl)
      ("popt" ,popt)
      ("libxml2" ,libxml2)))
   (native-inputs
    `(("pkg-config" ,pkg-config)
      ("libtool" ,libtool)
      ("autoconf" ,autoconf)
      ("automake" ,automake)
      ("flex" ,flex)
      ("bison" ,bison)
      ("glibc" ,glibc)
      ;; doc option
      ;; ("xmlto" ,xmlto)
      ;; ("asciidoc" ,asciidoc)
      ))
   (home-page "https://lttng.org/")
   (synopsis "LTTng userspace tracer libraries")
   (description "The user space tracing library, liblttng-ust, is the LTTng
user space tracer.  It receives commands from a session daemon, for example to
enable and disable specific instrumentation points, and writes event records
to ring buffers shared with a consumer daemon.")
   (license lgpl2.1+)))
