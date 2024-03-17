{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    opensc
  ];

  services.pcscd = {
    enable = true;
  };
}
