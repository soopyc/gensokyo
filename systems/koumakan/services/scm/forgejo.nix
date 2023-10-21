{
  pkgs,
  lib,
  ...
}: {
  services.forgejo = {
    package = pkgs.forgejo.overrideAttrs (_: prev: rec {
      pname = prev.pname + "-unstable";
      _commit = "5f83399d296fffefa5b8feddf23befa811cdecb4";

      version = "1.20.0+dev-g${builtins.substring 0 7 _commit}";
      src = prev.src.overrideAttrs (_: prev': {
        rev = _commit;
        hash = "sha256-s0lJhqO7ikdg1LtP2eJB+BDYxhHUNvMdPAP3mrSL2IU=";
      });

      ldflags =
        prev.ldflags
        ++ [
          "-X main.Version=${version}"
        ];

      vendorHash = "sha256-pBkQP9TcDGsxWwky05PLI59ERgXgg4s8CljeBxFVx6g=";
    });
  };
}
