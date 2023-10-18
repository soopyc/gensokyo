{
  pkgs,
  lib,
  ...
}: {
  services.forgejo = {
    package = pkgs.forgejo.overrideAttrs(_: prev: rec {
      pname = prev.pname + "-unstable";
      hash = "5f83399d296fffefa5b8feddf23befa811cdecb4";

      version = "1.20.0+dev-2171-g5f83399d29";
      src = prev.src.overrideAttrs(_: prev': {
        rev = hash;
        hash = lib.fakeHash;
      });

      vendorHash = lib.fakeHash;
    });
  };
}
