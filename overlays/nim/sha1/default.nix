final: prev:
{
  nimPackages = prev.nimPackages // {
    sha1 = prev.callPackage ./sha1.nix {};
  };
}
