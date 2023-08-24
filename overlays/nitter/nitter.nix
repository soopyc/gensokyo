# via https://github.com/NixOS/nixpkgs/blob/nixos-23.05/pkgs/servers/nitter/default.nix

{ lib
, fetchFromGitHub
, nimPackages
, nixosTests
, substituteAll
, unstableGitUpdater
}:

nimPackages.buildNimPackage rec {
  pname = "nitter";
  version = "unstable-2023-08-22+guest_accounts";

  src = fetchFromGitHub {
    owner = "zedeus";
    repo = "nitter";
    rev = "45808361af63e848ce322a27190d3ed7aba0723a";
    hash = "sha256-fwf0/hCf0z5QBo0WU9KbqbNRnuKyHXx8zz+qGNjAvaE=";
  };

  patches = [
    (substituteAll {
      src = ./nitter-version.patch;
      inherit version;
      inherit (src) rev;
      url = builtins.replaceStrings [ "archive" ".tar.gz" ] [ "commit" "" ] src.url;
    })
  ];

  buildInputs = with nimPackages; [
    flatty
    jester
    jsony
    karax
    markdown
    nimcrypto
    oauth
    packedjson
    redis
    redpool
    sass
    supersnappy
    zippy
  ];

  nimBinOnly = true;

  postBuild = ''
    nim c --hint[Processing]:off -r tools/gencss
    nim c --hint[Processing]:off -r tools/rendermd
  '';

  postInstall = ''
    mkdir -p $out/share/nitter
    cp -r public $out/share/nitter/public
  '';

  passthru = {
    tests = { inherit (nixosTests) nitter; };
    updateScript = unstableGitUpdater {};
  };

  meta = with lib; {
    homepage = "https://github.com/zedeus/nitter";
    description = "Alternative Twitter front-end";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ erdnaxe infinidoge ];
    mainProgram = "nitter";
  };
}
