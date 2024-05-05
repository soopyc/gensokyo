final: prev: {
  python3 = prev.python3.override {
    self = final.python3;

    packageOverrides = (final': prev': {
      pyscard = final.python3Packages.callPackage ./package.nix {
        inherit (final.darwin.apple_sdk.frameworks) PCSC; # apple carp
      };
    });
  };

  # probably some `rec` carp
  python3Packages = final.python3.pkgs;
}
