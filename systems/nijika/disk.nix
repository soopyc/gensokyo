{
  disko.devices.disk."root" = {
    type = "disk";
    device = "/dev/sda";

    content = {
      type = "gpt";
      partitions."swap" = {
        type = "0657fd6d-a4ab-43c4-84e5-0933c84b4f4f"; # swap
        size = "2G";
        content.type = "swap";
      };
    };
  };
}
