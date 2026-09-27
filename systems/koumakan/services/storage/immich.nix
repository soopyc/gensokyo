{ inputs, _system, ... }:
{
  services.immich = {
    enable = true;
    package = inputs.nixpkgs-unstable.legacyPackages.${_system}.immich;
    host = "koumakan.mist-nessie.ts.net";
  };
}
