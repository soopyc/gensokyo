# friendship ended with Makefile
# I LOVE justFILE!!!!!!

default: build

test:
	nixos-rebuild test --flake .#

build:
	nixos-rebuild build --flake .#

switch:
	nixos-rebuild switch --flake .#

utils recipe="list":
  @echo "Running utils/{{recipe}}"
  @cd utils && just {{recipe}}

update-input input:
  nix flake lock --update-input {{input}}

ebuild system:
  nix build -j8 .#nixosConfigurations."{{system}}".config.system.build.toplevel
