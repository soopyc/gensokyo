# I LOVE MAKEFILE!!!!!!

default: test

test:
	nixos-rebuild test --flake .#

build: 
	nixos-rebuild build --flake .#

switch:
	nixos-rebuild switch --flake .#
