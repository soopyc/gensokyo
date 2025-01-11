{pkgs, ...}: {
  default = pkgs.mkShellNoCC {
    packages = [
      pkgs.nixos-rebuild
      pkgs.nvd
    ];
  };
}
