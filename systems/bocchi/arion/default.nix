{...}: {
  imports = [
    ./authentik.nix
  ];

  virtualisation.arion = {
    backend = "podman-socket";
  };
}
