{
  lib,
  writeShellApplication,
  flakeLocation,
}:
writeShellApplication {
  name = "system";
  meta = {
    description = "A shortcut to run `just` in the local system flake directory.";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [soopyc];
  };

  # we could make this more robust by not using `just` and (hardcode?) commands in, but this is by far the easiest
  # and the most versatile method. if it works, it works and i'm not going to overcomplicate this
  text = ''
    if [ ! -e ${flakeLocation} ]; then
      echo "Could not find flake at ${flakeLocation}. Please reconfigure your system."
      exit 1
    fi

    cd ${flakeLocation}
    just "''${@:--l}"
  '';
}
