{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    luajit
    binutils
    libclang
    libgccjit
    gnumake
  ];
}
