{pkgs, ...}: {
  environment.systemPackages = [
    (pkgs.vesktop.override {
      withSystemVencord = false;
    })

    pkgs.osu-lazer-bin
  ];
}
