{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
# some items are sourced from https://jackson.dev/post/nix-reasonable-defaults/
lib.mkMerge [
  {
    nix.package = pkgs.nixVersions.latest;

    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        # "repl-flake"
      ];

      allowed-uris = [
        "github:"
        "git+https://patchy.soopy.moe/"
        "git+https://github.com/"
        "git+ssh://github.com/"
      ];

      substituters = [
        "https://cache.soopy.moe"
        "https://nonbunary.soopy.moe/gensokyo-global/"
      ];

      trusted-substituters = [
        "https://cache.soopy.moe"
        "https://nonbunary.soopy.moe/gensokyo-global/"
        "https://nixpkgs.reverse.proxy.internal.soopy.moe/"
      ];

      trusted-public-keys = [
        "cache.soopy.moe-1:0RZVsQeR+GOh0VQI9rvnHz55nVXkFardDqfm4+afjPo="
        "gensokyo-global:XiCN0D2XeSxF4urFYTprR+1Nr/5hWyydcETwZtPG6Ec="
      ];

      fallback = true;
      connect-timeout = 30;
      max-jobs = "auto";
      auto-optimise-store = true;
    };

    nix.gc = {
      automatic = true;
      dates = "weekly";
    };

    nix.registry =
      {
        n.flake = inputs.nixpkgs;
      }
      // (builtins.mapAttrs (_: flake: {inherit flake;})
        (lib.filterAttrs (n: _: n != "nixpkgs") inputs));

    # nix-index[-database]
    programs.nix-index.enable = true;
    programs.nix-index-database.comma.enable = true;
  }

  (lib.mkIf (!config.gensokyo.traits.sensitive) {
    nix.settings.trusted-users = [
      "@wheel"
      "builder"
    ];
  })
]
