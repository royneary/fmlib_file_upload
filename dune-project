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
  "git+https://github.com/royneary/fmlib.git#ca0172786b9881851075d3fcf59443fbe8ea3c76")
 (package
  (name fmlib_browser)))

(pin
 (url
  "git+https://github.com/royneary/fmlib.git#ca0172786b9881851075d3fcf59443fbe8ea3c76")
 (package
  (name fmlib_js)))

(pin
 (url
  "git+https://github.com/royneary/fmlib.git#ca0172786b9881851075d3fcf59443fbe8ea3c76")
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
