{
  _utils,
  lib,
  config,
  ...
}:
let
  secrets = _utils.setupSecrets config {
    namespace = "tangled/knot";
    secrets = [
      "master_key"
    ];
  };
in
{
  imports = [
    secrets.generate
    (secrets.mkTemplate "tangled.env" ''
      KNOT_MASTER_KEY="${secrets.placeholder "master_key"}"
    '')

    # n.b.: i am incredibly skeptical of their implementation of secret storage since it seems to be a bespoke implementation
    # that's not been audited, but i hope they know what they're doing.
  ];

  gensokyo.ports = {
    tangled-knot2-http = 34195;
    tangled-knot2-ssh = 2222;
  };

  services.tangled.knot-rs = {
    enable = true;
    user = "knot";
    stateDir = "/var/lib/tangled-knot";
    openFirewall = false; # do not touch my shit

    environmentFile = secrets.getTemplate "tangled.env";

    settings = {
      server = {
        hostname = "enanan.staging.soopy.moe";
        admins = lib.singleton "did:plc:jmr637khkdb2fdxxvoyj672m";
        listen_addr = "127.0.0.1:${toString config.gensokyo.ports.tangled-knot2-http}";
        ssh_listen_addr = "[::]:${toString config.gensokyo.ports.tangled-knot2-ssh}";
      };

      acl.admission = "open"; # i sure hope i don't regret this
      repo.mainBranch = "kitty";
      messages.fetch.motd = lib.singleton "[i] you are connected to {knot}";

      atproto.plc_directory = "https://plc.directory"; # you set billions of other crap defaults yet you don't set this one
      contact.email = "knot@soopy.moe";
      xrpc.trusted_proxy_header = "x-forwarded-for";
    };
  };

  services.nginx.virtualHosts."enanan.staging.soopy.moe" = _utils.mkSimpleProxy {
    port = config.gensokyo.ports.tangled-knot2-http;
    websockets = true;
    extraConfig = {
      useACMEHost = null;
      enableACME = true;
    };
  };
}
