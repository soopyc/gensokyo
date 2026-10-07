{ pkgs, lib, ... }:
{
  users.defaultUserShell = pkgs.zsh;
  programs.zsh = {
    enable = true;
    histSize = 50000;

    setOptions = lib.singleton "TRANSIENT_RPROMPT";

    # plugins
    syntaxHighlighting.enable = true;
    autosuggestions = {
      enable = true;
    };

    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
      ];
    };
  };

  programs.starship = {
    enable = true;
    settings = fromTOML (builtins.readFile ./starship.toml);

    # TODO: remove after jj support lands in stable
    package = pkgs.starship.overrideAttrs (final: _: {
       version = "unstable-2026-10-05-d4d0459c5";
       # cargoHash = "";
       doCheck = false;
       src = pkgs.fetchFromGitHub {
         owner = "starship";
         repo = "starship";
         rev = "d4d0459c5c24ba8f64663af8714f7858d7fb357b";
         hash = "sha256-mO+25Q+v7z5XUT7DVLRwDjW3htc+kmUOKavhuEM5654=";
       };
       cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
         inherit (final) src version;
         pname = "${final.pname}-cargo-deps";
         hash = "sha256-5R2CdOA5FVWswVbGxdacRQXd+M1yTrSNJwSfBNhjomQ=";
       };
    });
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.pay-respects = {
    enable = true;
    alias = "fuck";
    aiIntegration = lib.mkForce false;
  };

  # conflicts with comma
  programs.command-not-found.enable = false;
}
