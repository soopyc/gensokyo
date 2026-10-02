{
  lib,
  config,
  ...
}:
let
  inherit (lib) types;
  cfg = config.gensokyo.ports;
in
{
  # for our purposes (bookkeeping) we do not make a distinction between tcp and udp ports.
  options.gensokyo.ports = lib.mkOption {
    #apply = lib.mapAttrs (lib.const toString); # self constructed horrors beyond my ability to comprehend
    #apply = lib.mapAttrs (_: toString); # part 2
    #apply = x: lib.mapAttrs (_: v: toString v) x; # de-horrored
    type = types.attrsOf types.ints.u16;
    description = "An attribute set of ports where attr names are services.";
    example = {
      nginx = 80;
      nginxSecure = 443;
    };
  };

  config = {
    assertions =
      let
        # i'd love to show def locations but i cannot do that without effectively re-implementing or at least re-evaluating the merging logic
        groups = builtins.groupBy (e: toString e.value) (lib.attrsToList cfg);
        collisions = lib.foldlAttrs (
          final: k: v:
          final
          ++ (
            if builtins.length v == 1 then
              [ ]
            else
              lib.singleton {
                port = k;
                services = map (e: e.name) v;
              }
          )
        ) [ ] groups;
      in
      lib.singleton {
        assertion = builtins.length collisions == 0;
        message = ''
          Detected port collision(s):
            ${lib.concatStringsSep "\n  " (
              map (
                c:
                "- Port ${c.port} is in use by ${toString (builtins.length c.services)} different services: ${lib.concatStringsSep ", " c.services}"
              ) collisions
            )}
        '';
      };
  };
}
