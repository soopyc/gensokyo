{ pkgs, ... }:
{
  programs.steam = {
    enable = true;

    extraCompatPackages = [
      pkgs.proton-ge-bin
    ];
  };

  environment.systemPackages = [
    pkgs.protontricks
  ];
}
