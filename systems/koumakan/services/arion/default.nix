{...}: {
  imports = [
    ./breezewiki.nix
  ];

  virtualisation.arion.backend = "podman-socket";
  virtualisation.podman = {
    enable = true;
    dockerSocket.enable = true;
    defaultNetwork.settings.dns_enabled = true;
  };
}
