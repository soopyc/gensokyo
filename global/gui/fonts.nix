{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
lib.mkIf config.gensokyo.traits.gui {
  fonts.packages = [
    pkgs.nerd-fonts.hurmit
    pkgs.nerd-fonts.fira-mono

    pkgs.cozette
    pkgs.cascadia-code
    pkgs.noto-fonts
    pkgs.noto-fonts-cjk-sans
    pkgs.noto-fonts-emoji-blob-bin

    inputs.mystia.packages.${pkgs.system}.nishiki-teki
  ];

  fonts.fontconfig = {
    localConf = ''
      <?xml version="1.0"?>
      <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
      <fontconfig>
      <!-- XML is stupid -->

      <!-- DID NOT WORK -->
      <!-- <alias>
        <family>monospace</family>
        <prefer>
          <family>DejaVu Sans Mono</family>
          <family>Hurmit Nerd Font</family>
          <family>FiraMono Nerd Font</family>
        </prefer>
      </alias> -->

      <!-- DID NOT WORK -->
      <!-- <match target="pattern">
        <test qual="any" name="family" compare="eq"><string>FreeMono</string></test>
        <edit name="family" mode="assign" binding="same"><string>Noto Sans Symbols 2</string></edit>
      </match> -->

      <selectfont>
        <rejectfont>
          <pattern><patelt name="family"><string>FreeMono</string></patelt></pattern>
        </rejectfont>
      </selectfont>

      </fontconfig>
    '';
  };
}
