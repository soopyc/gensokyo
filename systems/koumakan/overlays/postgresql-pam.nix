final: prev: {
  postgresql_15_pam = prev.postgresql_15.overrideAttrs (_: prevAttrs: {
    configureFlags = prevAttrs.configureFlags ++ ["--with-pam"];
    buildInputs = prevAttrs.buildInputs ++ [prev.pam];
  });
}
