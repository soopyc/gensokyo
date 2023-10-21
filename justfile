# friendship ended with Makefile
# I LOVE justFILE!!!!!!

# build the current configuration
build system="":
	nixos-rebuild build --flake .#{{system}}

# build and test the configuration, but don't switch
test system="":
	nixos-rebuild test --flake .#{{system}}

# switch to the current configuration
switch system="":
	nixos-rebuild switch --flake .#{{system}}

# run utility programs
utils recipe="list":
  @echo "Running utils/{{recipe}}"
  @cd utils && just {{recipe}}

# update an input in the flake lockfile
update-input input:
  nix flake lock --update-input {{input}}

# REMOVED: build a system from the flake on a non-nixos platform
# ebuild system:
#   nix build -j8 .#nixosConfigurations."{{system}}".config.system.build.toplevel

# vm system:
#   nix build -j8 .#nixosConfigurations."{{system}}".config.system.build.vm

# build a vm for a system
vm system run="true" bootloader="false":
  nixos-rebuild build-vm{{if bootloader == "true" {"-with-bootloader"} else {""} }} --flake .#{{system}}
  {{if run == "true" {"./result/bin/run-"+system+"-vm"} else {""} }}
