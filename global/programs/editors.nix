{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = false;
    viAlias = true;
    vimAlias = true;
  };

  environment.systemPackages = with pkgs; [
    helix
  ];
  environment.variables.EDITOR = "hx";
}
