{
  pkgs,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage {
  pname = "tiny-dfr";
  version = "0.3.0-unstable-2024-07-10";

  src = fetchFromGitHub {
    owner = "WhatAmISupposedToPutHere";
    repo = "tiny-dfr";
    rev = "a066ded870d8184db81f16b4b55d0954b2ab4c88";
    hash = "sha256-++TezIILx5FXJzIxVfxwNTjZiGGjcZyih2KBKwD6/tU=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  nativeBuildInputs = with pkgs; [
    pkg-config
  ];

  buildInputs = with pkgs; [
    udev
    glib
    pango
    cairo
    gdk-pixbuf
    libxml2
    libinput
  ];

  postPatch = ''
    substituteInPlace src/main.rs src/config.rs \
      --replace "/usr/share/tiny-dfr/" "$out/share/tiny-dfr/"
  '';

  postInstall = ''
    mkdir -p $out/etc $out/share

    cp -r etc/udev $out/etc/
    cp -r share/tiny-dfr $out/share/
  '';

  meta = with pkgs.lib; {
    description = "The most basic dynamic function row daemon possible";
    homepage = "https://github.com/WhatAmISupposedToPutHere/tiny-dfr";
    license = with licenses; [asl20 mit];
    maintainers = with maintainers; [soopyc];
  };
}
