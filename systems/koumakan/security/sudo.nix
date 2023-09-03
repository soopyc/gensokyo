{pkgs, ...}: {
  security.sudo.extraConfig = ''
    Defaults insults
  '';
  security.sudo.package = pkgs.sudo.override {withInsults = true;};
}
