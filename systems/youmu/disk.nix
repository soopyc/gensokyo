{ lib, pkgs, ... }:
let
  mkPersistDir = directory: mode: { inherit directory mode; };
in
{
  disko.devices = {
    disk."root" = {
      type = "disk";
      device = "/dev/nvme0n1";

      content = {
        type = "gpt";
        partitions."efi" = {
          size = "500M";
          type = "c12a7328-f81f-11d2-ba4b-00a0c93ec93b"; # EFI Partition
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/efi";
            mountOptions = lib.singleton "umask=0077";
          };
        };

        partitions."swap" = {
          type = "0657fd6d-a4ab-43c4-84e5-0933c84b4f4f"; # swap
          size = "8G";
          content.type = "swap";
        };

        partitions."data" = {
          size = "100%";
          type = "6a898cc3-1dd2-11b2-99a6-080020736631";
          content.type = "zfs";
          content.pool = "zroot";
        };
      };
    };

    zpool."zroot" = {
      type = "zpool";
      mountpoint = null;
      rootFsOptions = {
        canmount = "off";
      };

      datasets = {
        root = {
          type = "zfs_fs";
          mountpoint = "/";
          postCreateHook = "zfs list -t snapshot -H -o name | grep -q '^zroot/root@blank$' || zfs snapshot zroot/root@blank";
        };

        nix = {
          type = "zfs_fs";
          mountpoint = "/nix";
        };

        persist = {
          type = "zfs_fs";
          mountpoint = "/persist";
        };
      };
    };
  };

  fileSystems."/nix".neededForBoot = true; # N.B. Not entirely necessary, but setting for good measure.
  fileSystems."/persist".neededForBoot = true;

  boot.initrd.systemd.services."zfs-rollback-blank" = {
    script = ''
      # zpool wait -p -Td -t initialize zroot 1
      zfs rollback -r zroot/root@blank || true
      echo "✨ Welcome to a new boot"
    '';

    serviceConfig.Type = "oneshot";
    path = lib.singleton pkgs.zfs;
    after = lib.singleton "zfs-import-zroot.service";
    before = lib.singleton "sysroot.mount";
    wantedBy = lib.singleton "initrd.target";
  };

  environment.persistence."/persist" = {
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_rsa_key"
    ];

    directories = [
      "/var/lib/nixos"
      "/var/lib/postgresql"
      "/var/log/journal"
      "/var/lib/vnstat"
      "/var/lib/private/kea" # dynamicuser is enabled
      (mkPersistDir "/var/lib/tailscale" "0700")
    ];
  };
}
