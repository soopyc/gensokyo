{ pkgs, ... }:

{
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    max-jobs = "auto";
    auto-optimise-store = true;
  };

  nix.package = pkgs.nixFlakes;
}
