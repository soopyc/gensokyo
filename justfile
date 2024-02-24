# friendship ended with Makefile
# I LOVE justFILE!!!!!!

# modules are unstable atm
# mod utils

# build the current configuration
build system="":
	nixos-rebuild -v build --flake .#{{system}} --log-format internal-json |& nom --json

# build and test the configuration, but don't switch
test system="":
	nixos-rebuild -v -L test --flake .#{{system}} --log-format internal-json |& nom --json

# switch to the current configuration
switch system="": sudo_cache
	sudo nixos-rebuild -v -L switch --flake .#{{system}} --log-format internal-json |& nom --json

# literally nixos-rebuild boot with a different name
defer system="": sudo_cache
	sudo nixos-rebuild -v -L boot --flake .#{{system}} --log-format internal-json |& nom --json

# run utility programs
utils recipe="list":
	@echo "Running utils/{{recipe}}"
	@just -d utils -f utils/justfile {{recipe}}

# update an input in the flake lockfile
update-input input:
	nix flake lock --update-input {{input}}

# update everything in flake.lock and commit that
flake-update:
	nix flake update --commit-lock-file

# build a vm for a system
vm system run="true" bootloader="false":
	nixos-rebuild -v -L build-vm{{if bootloader == "true" {"-with-bootloader"} else {""} }} --flake .#{{system}}
	{{if run == "true" {"./result/bin/run-"+system+"-vm"} else {""} }}

[private]
sudo_cache:
	@sudo -v
