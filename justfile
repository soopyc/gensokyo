# friendship ended with Makefile
# I LOVE justFILE!!!!!!

# modules are unstable atm
# mod utils

# build the current configuration
build system="" +extra_args="":
	nixos-rebuild -v -L --keep-going --accept-flake-config --log-format internal-json --flake .#{{system}} build \
		{{extra_args}} |& nom --json
	{{ if system == "" {"nvd diff /run/current-system result"} else {""} }}

# build and test the configuration, but don't switch
test system="":
	nixos-rebuild -v -L test --flake .#{{system}} --accept-flake-config

deploy system:
	nixos-rebuild switch --flake .#{{system}} --target-host {{system}} --use-remote-sudo -v -L --use-substitutes

dry-deploy system:
	nixos-rebuild build --flake .#{{system}} --target-host {{system}} --use-remote-sudo -v -L --use-substitutes

# switch to the current configuration
switch system="": sudo_cache
	sudo nixos-rebuild -v -L switch --flake .#{{system}} --accept-flake-config --keep-going

# literally nixos-rebuild boot with a different name
defer system="": sudo_cache
	sudo nixos-rebuild -v -L boot --flake .#{{system}} --accept-flake-config

build-all: (for-all-systems 'build' 'true')
deploy-all: (for-all-systems 'deploy' '!system.config.gensokyo.traits.sensitive')

# check the flake
check:
	nix flake check

# delete old nixos generations and GCs the store.
gc older_than="3d": sudo_cache
	sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than {{older_than}}
	sudo nix store gc -vL

# run utility programs
utils recipe="list" +extras="":
	@echo "Running utils/{{recipe}}"
	@just -d utils -f utils/justfile {{recipe}} {{extras}}

# update an input in the flake lockfile
update-input input:
	nix flake lock --update-input {{input}}

# update everything in flake.lock and commit that
flake-update:
	nix flake update --commit-lock-file

# list changes in the current config vs the system config
diff:
	nvd diff /run/current-system result

# build a vm for a system
vm system run="true" bootloader="false":
	nixos-rebuild -v -L build-vm{{if bootloader == "true" {"-with-bootloader"} else {""} }} --flake .#{{system}}
	{{if run == "true" {"./result/bin/run-"+system+"-vm"} else {""} }}

[private]
sudo_cache:
	@sudo -v

[private]
for-all-systems recipe filter:
	#!/usr/bin/env bash
	set -euxo pipefail
	for system in $(nix eval --apply 'configs: builtins.map (system: system.config.networking.hostName) (builtins.filter (system: {{filter}}) (builtins.attrValues configs))' .#nixosConfigurations --json | jq '.[]' | xargs); do
		just {{recipe}} ${system}
	done
