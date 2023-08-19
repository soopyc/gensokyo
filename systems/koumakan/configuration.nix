# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ ... }:

{
  imports = [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      ../../global/core.nix
      ../../global/programs

      ./networking
      ./certificates
      ./security
      ./services
  ];

  nixpkgs.overlays = import ../../overlays;

  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot/efi";
  };

  boot.loader.systemd-boot = {
    enable = true;
    graceful = true;
    netbootxyz.enable = true;
  };

  boot.loader.grub = {
    enable = false;
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

  # Just don't change this :p
  system.stateVersion = "23.05"; # Did you read the comment?
}
