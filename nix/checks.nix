{
  inputs,
  pkgs,
}:
{
  deadcode = pkgs.stdenvNoCC.mkDerivation {
    name = "deadcode_check";
    src = inputs.self;
    dontPatch = true;
    dontConfigure = true;

    buildInputs = with pkgs; [ deadnix ];
    buildPhase = ''
      set -euo pipefail

      deadnix -f .
      echo "All done!"
    '';

    installPhase = "touch $out";
  };
}
