# copied and adapted from https://github.com/NixOS/nixpkgs/blob/nixos-23.05/pkgs/development/nim-packages/jsony/default.nix
{ lib, nimPackages, fetchFromGitHub }:

nimPackages.buildNimPackage rec {
  pname = "oauth";
  version = "b8c163b0d9cfad6d29ce8c1fb394e5f47182ee1c";

  src = fetchFromGitHub {
    owner = "CORDEA";
    repo = pname;
    rev = version;
    sha256 = "0k5slyzjngbdr6g0b0dykhqmaf8r8n2klbkg2gpid4ckm8hg62v5";
  };

  meta = {
    homepage = src.meta.homepage;
    downloadPage = src.url;
    description = "OAuth library for nim";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
