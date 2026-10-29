{
  disko.devices = {
    disk."root" = {
      type = "disk";
      device = "/dev/nvme0n1";

      content = {
        type = "gpt";
        partitions."swap" = {
          type = "0657fd6d-a4ab-43c4-84e5-0933c84b4f4f"; # swap
          size = "8G";
          content.type = "swap";
        };
      };
    };
  };

  environment.persistence."/persist".directories = [
    "/var/lib/postgresql"
    "/var/lib/vnstat"
    "/var/lib/kea"
  ];
}
