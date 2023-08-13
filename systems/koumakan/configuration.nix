# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      
      ../../global/core.nix
      ../../global/programs
      ./networking
      ./security/pam.nix
    ];

  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot/efi";
  };

  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    theme = pkgs.nixos-grub2-theme;
  };

  time.timeZone = "Asia/Hong_Kong";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.cassie = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh = {
        authorizedKeys.keyFiles = [ ../../creds/ssh/cassie ];
    };
    # packages = with pkgs; [];
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # Just don't change this :p
  system.stateVersion = "23.05"; # Did you read the comment?
}
