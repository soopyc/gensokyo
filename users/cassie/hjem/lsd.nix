{ pkgs, lib, ... }:
{
  hjem.users.cassie = {
    packages = with pkgs; [ lsd ];

    xdg.config.files = {
      "hjem-zsh-glue.zsh".text = ''
        # lsd aliases
        alias ls='lsd --git'
        alias l='ls -alh'
        alias ll='lsd -l'
        alias la='lsd -la'
        alias laa='lsd -a'
        alias lt='lsd --tree'

        export ls l ll la laa lt
      '';

      "lsd/colors.yaml".source = pkgs.fetchurl {
        url = "https://raw.github.com/catppuccin/lsd/92d4a10318e5dfde29dbe52d166952dbf1834a0d/themes/catppuccin-latte/colors.yaml";
        hash = "sha256-mAt7CGsfAzisMq2pR66v47tFjE5SmsCeoGcLGXn5xz8=";
      };

      "lsd/config.yaml" = {
        value = {
          color.theme = "custom";
        };
        generator = lib.generators.toJSON { };
      };
    };
  };
}
