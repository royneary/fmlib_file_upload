{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      ...
    }:
    let
      supportedSystems = [
        "x86_64-linux"
      ];

      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
    in
    {
      devShell = forAllSystems (
        system:
        let
          overlays = [ ];
          pkgs = import nixpkgs { inherit system overlays; };
          pkgs-unstable = import nixpkgs-unstable { inherit system overlays; };
        in
        pkgs.mkShell {
          name = "ocaml devshell";

          shellHook = ''
            unset OCAMLFIND_DESTDIR
          '';

          nativeBuildInputs = with pkgs; [
            pkgs-unstable.dune_3
            pkgs-unstable.ocamlPackages.ocamlformat
            pkgs-unstable.ocamlPackages.ocaml-lsp
            pkgs-unstable.ocamlPackages.odoc
            gmp
            pkg-config
            openssl
            libev
          ];
        }
      );
    };
}
