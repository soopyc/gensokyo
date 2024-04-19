{pkgs, ...}: {
  fonts.packages = [
    (
      pkgs.nerdfonts.override {
        fonts = [
          "Hermit"
          "FiraMono"
        ];
      }
    )
    pkgs.noto-fonts
    pkgs.noto-fonts-cjk-sans
    pkgs.noto-fonts-emoji-blob-bin
  ];
}
