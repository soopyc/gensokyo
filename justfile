# friendship ended with Makefile
# I LOVE justFILE!!!!!!

# build the current configuration
build:
	nixos-rebuild build --flake .#

# build and test the configuration, but don't switch
test:
	nixos-rebuild test --flake .#

# switch to the current configuration
switch:
	nixos-rebuild switch --flake .#

# run utility programs
utils recipe="list":
  @echo "Running utils/{{recipe}}"
  @cd utils && just {{recipe}}

# update an input in the flake lockfile
update-input input:
  nix flake lock --update-input {{input}}

# build the flake on a non-nixos platform
ebuild system:
  nix build -j8 .#nixosConfigurations."{{system}}".config.system.build.toplevel
