{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
lib.mkIf config.gensokyo.traits.gui {
  fonts.packages = with pkgs; [
    inputs.mystia.packages.${stdenv.hostPlatform.system}.maple-soopy
    nerd-fonts.fantasque-sans-mono

    cozette
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji-blob-bin

    last-resort
    # inputs.mystia.packages.${pkgs.system}.nishiki-teki
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

      <!-- doesn't work...
      <match target='font'>
          <test name='fontformat' compare='not_eq'>
              <string/>
          </test>
          <test name='family'>
              <string>FantasqueSansM Nerd Font Mono</string>
          </test>
          <edit name='fontfeatures' mode='assign_replace'>
              <string>ss01</string>
          </edit>
      </match>
      -->

      <selectfont>
        <rejectfont>
          <pattern><patelt name="family"><string>FreeMono</string></patelt></pattern>
        </rejectfont>
      </selectfont>
      </fontconfig>
    '';
  };
}
