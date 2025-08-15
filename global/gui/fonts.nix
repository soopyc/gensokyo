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

      <alias binding="same">
        <family>Nishiki-Teki</family>
        <prefer>
          <family>Noto Sans CJK JP</family>
        </prefer>
        <default><family>sans-serif</family></default>
      </alias>

      <selectfont>
        <rejectfont>
          <pattern><patelt name="family"><string>FreeMono</string></patelt></pattern>
        </rejectfont>
      </selectfont>
      </fontconfig>
    '';
  };
}
