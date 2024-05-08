{stdenvNoCC}: stdenvNoCC.mkDerivation (final: {
  name = "bocchi-landing";
  src = ./.;

  installPhase = ''
    mkdir $out
    cp ${final.src}/* $out/
  '';
})
