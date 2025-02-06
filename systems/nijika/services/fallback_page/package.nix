{stdenvNoCC}:
stdenvNoCC.mkDerivation (final: {
  name = "nijika-landing";
  src = ./.;

  installPhase = ''
    mkdir $out
    cp ${final.src}/* $out/
  '';
})
