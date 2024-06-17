{...}: {
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
  };

  users.groups.docker.members = [
    "cassie"
  ];
}
