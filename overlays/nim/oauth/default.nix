final: prev:
{
  nimPackages = prev.nimPackages // {
    oauth = prev.callPackage ./oauth.nix {};
  };
}
