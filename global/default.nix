# This is a NixOS module, you cannot use this as a standalone file.
# Other files may be though, but things that starts with {...}: most definitely aren't.
{inputs, ...}: {
  imports = [
    ./core.nix
    ./traits
    ./programs

    ./home.nix
    ../users

    inputs.sops-nix.nixosModules.sops
    inputs.catppuccin.nixosModules.catppuccin
    inputs.home-manager.nixosModules.home-manager
    inputs.nix-index-database.nixosModules.nix-index
  ];
}
