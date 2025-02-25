{ pkgs, ... }:
pkgs.mkShell {
  buildInputs =
    with pkgs; [
      nixfmt-rfc-style
      typst
    ];
}
