{pkgs, ...}: {
  environment.systemPackages = [
    (pkgs.vesktop.override {
      withSystemVencord = false;
    })
  ];

  # this is in degeneracy because no one likes printers
  services.printing.enable = true;
}
