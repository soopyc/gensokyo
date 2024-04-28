{ zstd
, lib
, fetchzip
, stdenvNoCC
}: stdenvNoCC.mkDerivation (final: {
  name = "brcm-mac-firmware";

  # src = requireFile {
  #   name = "firmware.tar.gz";
  #   sha256Hash = "0x41h7xnrif5llwj212hv41a0jhm0g2my524gjbsfkzdgbpsg9wq";
  #   message = ''
  #     The Apple Mac Wi-Fi and Bluetooth firmware tarball cannot be found in your Nix store.
  #     Due to licensing restrictions, we are unable to download this file automatically online and/or distribute it.

  #     To obtain this file, follow the instructions written in the t2linux wiki on **macOS**:
  #      -> https://wiki.t2linux.org/guides/wifi-bluetooth/#on-macos

  #     Note that **an existing macOS installation** is required to proceed with the steps above.
  #     If you have removed macOS, we cannot provide any help. You might have to consult your friends or reinstall macOS.

  #     After obtaining the firmware, reboot into NixOS and add the newly acquired tarball to the Nix store with the following command
  #      -> nix-prefetch-url file:///boot/efi/firmware.tar.gz --unpack

  #     This package should properly build afterwards. You may also choose to ignore the outlined steps and override this `src` package
  #     with overrideAttrs. Consult the nixpkgs manual for more information.

  #     If you have any questions, feel free to reach out at the #nixos channel in the t2linux discord guild (invite accessible from
  #     https://t2linux.org) or directly contact one of the maintainers defined in this package.
  #   '';
  # };

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

