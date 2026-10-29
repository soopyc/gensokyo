{
  disko.devices.disk."root" = {
    type = "disk";
    device = "/dev/sda";

    content = {
      type = "gpt";
      partitions."bios" = {
        size = "1M";
        type = "21686148-6449-6e6f-744e-656564454649"; # Hah!IdontNeedEFI
      };
    };
  };

  # defaults now configured via config.gensokyo.traits.ephemeral
  environment.persistence."/persist".directories = [ "/var/lib/stalwart" ];
}
