{...}: {
  imports = [
    ./bocchi.nix
    ./gateway.nix
  ];

  gensokyo.presets.certificates = true;
}
