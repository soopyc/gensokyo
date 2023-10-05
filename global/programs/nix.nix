{
  inputs,
  pkgs,
  lib,
  ...
}:
# some items are sourced from https://jackson.dev/post/nix-reasonable-defaults/
{
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
      "repl-flake"
    ];

    substituters = [
      "https://nonbunary.soopy.moe/gensokyo-systems/"
      "https://nonbunary.soopy.moe/gensokyo-global/"
    ];

    trusted-substituters = [
      "https://nonbunary.soopy.moe/gensokyo-systems/"
      "https://nonbunary.soopy.moe/gensokyo-global/"
    ];

    trusted-public-keys = [
      "gensokyo-systems:r/Wx649dPuQrCN9Pgh3Jic526zQNk3oWMqYJHnob/Ok="
      "gensokyo-global:XiCN0D2XeSxF4urFYTprR+1Nr/5hWyydcETwZtPG6Ec="
    ];

    fallback = true;
    connect-timeout = 30;
    max-jobs = "auto";
    auto-optimise-store = true;
  };

  nix.package = pkgs.nixFlakes;
  nix.registry =
    {
      n.flake = inputs.nixpkgs;
    }
    // (builtins.mapAttrs (_: flake: {inherit flake;})
      (lib.filterAttrs (n: _: n != "nixpkgs") inputs));
}
