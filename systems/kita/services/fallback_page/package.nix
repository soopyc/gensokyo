{stdenvNoCC}:
stdenvNoCC.mkDerivation (final: {
  name = "kita-landing";
  src = ./.;

  installPhase = ''
    mkdir $out
    cp ${final.src}/* $out/
  '';
})
