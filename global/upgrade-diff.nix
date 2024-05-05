# Thank you https://github.com/luishfonseca/dotfiles/blob/ab7625ec406b48493eda701911ad1cd017ce5bc1/modules/upgrade-diff.nix
{
  lib,
  pkgs,
  ...
}: {
  system.activationScripts.diff = {
    supportsDryActivation = true;
    text = ''
      if [[ -e /run/current-system ]]; then
        ${lib.getExe pkgs.nvd} --color always --nix-bin-dir=${pkgs.nix}/bin diff /run/current-system "$systemConfig"
      else
        echo "Couldn't find /run/current-system. Are we booting? Exiting gracefully."
     fi
    '';
  };
}
