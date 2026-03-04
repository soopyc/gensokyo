# Thank you https://github.com/luishfonseca/dotfiles/blob/ab7625ec406b48493eda701911ad1cd017ce5bc1/modules/upgrade-diff.nix
{
  lib,
  pkgs,
  ...
}:
{
  system.activationScripts.diff = {
    supportsDryActivation = true;
    text = ''
       if [[ -e /run/current-system ]]; then
         ${lib.getExe pkgs.dix} --color always /run/current-system "$systemConfig"
      fi
    '';
  };
}
