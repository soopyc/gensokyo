{...}: {
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
  };

  users.groups.docker.members = [
    "cassie"
  ];

  system.activationScripts.lock-docker-group = {
    text = "gpasswd -R docker";
  };
}
