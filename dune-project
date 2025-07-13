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
  "git+https://github.com/royneary/fmlib.git#9d4a987ba8e8788eb609020b3ca503c10730c8d3")
 (package
  (name fmlib_browser)))

(pin
 (url
  "git+https://github.com/royneary/fmlib.git#9d4a987ba8e8788eb609020b3ca503c10730c8d3")
 (package
  (name fmlib_js)))

(pin
 (url
  "git+https://github.com/royneary/fmlib.git#9d4a987ba8e8788eb609020b3ca503c10730c8d3")
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
