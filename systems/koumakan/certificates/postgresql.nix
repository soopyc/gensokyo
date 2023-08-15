{ ... }:

{
  # PostgreSQL only certificate
  security.acme.certs."phant.soopy.moe" = {
    group = "postgres";
  };
}
