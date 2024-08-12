{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    luajit
    binutils
    # libclang
    clang
    libgccjit
    gnumake
  ];
}
