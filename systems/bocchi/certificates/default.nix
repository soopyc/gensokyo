{...}: {
  imports = [
    ./bocchi.nix
    ./bsky-sandbox.nix
  ];

  gensokyo.presets.certificates = true;
}
