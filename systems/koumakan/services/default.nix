{ pkgs, ... }: 
{
  imports = [
    ./nginx.nix
    
    # databases
    ./redis.nix

    ./static-sites
  ];
}
