{ pkgs ? import <nixpkgs> { config.allowUnfree=true; } }:

pkgs.mkShell {
  name = "platform-env";

  buildInputs = with pkgs; [
    terraform
    kustomize
    fluxcd
    helm
    age
    sops
  ];

  shellHook = ''
    echo "Dev-shell with terraform, kustomize, flux och helm loaded."
  '';
}
