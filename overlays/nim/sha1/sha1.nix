# copied and adapted from https://github.com/NixOS/nixpkgs/blob/nixos-23.05/pkgs/development/nim-packages/jsony/default.nix
{ lib, nimPackages, fetchFromGitHub }:

nimPackages.buildNimPackage rec {
  pname = "sha1";
  version = "92ccc5800bb0ac4865b275a2ce3c1544e98b48bc";

  src = fetchFromGitHub {
    owner = "onionhammer";
    repo = pname;
    rev = version;
    sha256 = "sha256-tWHouIa6AFRmbvJaMsoWKNZX7bzqd3Je1kJ4rVHb+wM=";
  };

  meta = {
    homepage = src.meta.homepage;
    downloadPage = src.url;
    description = "SHA-1 hashing library for nim";
    license = lib.licenses.mit;  # the author did something to it so i'm not exactly sure, but the previous ver. is mit.
    maintainers = [ ];
  };
}
