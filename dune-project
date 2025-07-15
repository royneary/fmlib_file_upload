(lang dune 3.19)

(name file_upload)

(generate_opam_files true)

(source
 (github username/reponame))

(authors "Author Name <author@example.com>")

(maintainers "Maintainer Name <maintainer@example.com>")

(license LICENSE)

(documentation https://url/to/documentation)

(pin
 (url
  "git+https://github.com/hbr/fmlib.git#aff0f75f09e019a9cd98c53eff85f87bdb03b42b")
 (package
  (name fmlib_browser)))

(pin
 (url
  "git+https://github.com/hbr/fmlib.git#aff0f75f09e019a9cd98c53eff85f87bdb03b42b")
 (package
  (name fmlib_js)))

(pin
 (url
  "git+https://github.com/hbr/fmlib.git#aff0f75f09e019a9cd98c53eff85f87bdb03b42b")
 (package
  (name fmlib_std)))

(package
 (name file_upload)
 (synopsis "A short synopsis")
 (description "A longer description")
 (depends ocaml dream fmlib_browser)
 (tags
  ("add topics" "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
