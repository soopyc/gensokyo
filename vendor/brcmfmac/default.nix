{
  zstd,
  lib,
  fetchzip,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation (final: {
  name = "brcm-mac-firmware";

  src = fetchzip {
    nativeBuildInputs = [zstd];
    stripRoot = false;
    url = "https://mirror.funami.tech/arch-mact2/os/x86_64/apple-bcm-firmware-14.0-1-any.pkg.tar.zst";
    hash = "sha256-7HFXStpTkBG8wujsO8OTm5x+h17mqRiGSrS/Srv49Yg=";
  };

  dontBuild = true;
  dontConfigure = true; # don't do unnecessary stuff.

  installPhase = ''
    finalDir="$out/lib/firmware"
    mkdir -p "$finalDir"
    cp -r ${final.src}/usr/lib/firmware/brcm "$finalDir"
  '';

  meta = {
    description = "Collection of Wi-Fi and Bluetooth firmware files for Apple Mac devices.";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [soopyc];
    platforms = lib.platforms.linux;
  };
})
