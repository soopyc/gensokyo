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
        "ca-derivations"
      ];

      allowed-uris = [
        "github:"
        "git+https://patchy.soopy.moe/"
        "git+https://github.com/"
        "git+ssh://github.com/"
      ];

      substituters = [
        "https://cache.soopy.moe"
      ];

      trusted-substituters = [
        "https://cache.soopy.moe"
      ]
      # our own proxies
      ++ (map (loc: "https://${loc}.cno.proxy.soopy.moe") [
        "syd"
        "nbg"
        "osa"
      ]);

      trusted-public-keys = [
        "cache.soopy.moe-1:0RZVsQeR+GOh0VQI9rvnHz55nVXkFardDqfm4+afjPo="
      ];

      fallback = true;
      connect-timeout = 30;
      max-jobs = "auto";
      auto-optimise-store = true;
      download-buffer-size = 268435456; # 256 MiB

      flake-registry = ""; # use explicitly defined registry values below
      log-lines = 5; # rarely useful > 5, we have to scroll to find the error anyways if set to 25.

      # future proofing
      trace-import-from-derivation = true;
      use-xdg-base-directories = true;
      lint-url-literals = "warn";
      # lint-short-path-literals = "warn"; # nixpkgs has them, quite annoying
    };

    nix.gc = {
      automatic = true;
      dates = "weekly";
    };

    nix.registry =
      let
        mkTarball = name: url: {
          ${name} = {
            from = {
              type = "indirect";
              id = name;
            };
            to = {
              inherit url;
              type = "tarball";
            };
          };
        };
      in
      {
        self.flake = inputs.self;
        n.flake = inputs.nixpkgs;
        nu.flake = inputs.nixpkgs-unstable;
      }
      // mkTarball "nixpkgs" "https://nixpkgs.dev/channel/nixos-26.05"
      // mkTarball "nixpkgs-unstable" "https://nixpkgs.dev/channel/nixos-unstable";

    # // (builtins.mapAttrs (_: flake: { inherit flake; }) (
    #   lib.filterAttrs (n: _: n != "nixpkgs") inputs
    # ));

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
