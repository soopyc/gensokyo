# I LOVE MAKEFILE!!!!!!

default: build

test:
	nixos-rebuild test --flake .#

build:
	nixos-rebuild build --flake .#

switch:
	nixos-rebuild switch --flake .#
