{ pkgs, ... }: 
{
  imports = [
    ./nginx.nix
    ./static-sites
  ];
}
