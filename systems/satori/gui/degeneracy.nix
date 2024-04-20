{pkgs, ...}: {
  environment.systemPackages = [
    (pkgs.vesktop.override {
      withSystemVencord = false;
    })
  ];
}
