{ ... }:
{
  imports = [
    ./fallback_page
    ./mail

    ./dns.nix
    ./postgresql.nix
    ./radicale.nix
    ./gatus.nix
  ];
}
