{...}: {
  imports = [
    ./hydra
    ./fallback_page

    ./bsky-pds.nix
  ];

  gensokyo.presets.nginx = true;
}
