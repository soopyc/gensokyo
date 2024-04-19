{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.vscode.fhs
  ];
}
