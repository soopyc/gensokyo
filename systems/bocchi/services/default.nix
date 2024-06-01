{...}: {
  imports = [
    ./nginx.nix

    ./hydra
    ./fallback_page
  ];
}
