{ pkgs, ... }:
{
  environment.systemPackages = [
    # only renko is powerful enough to run this
    pkgs.blender
  ];
}
