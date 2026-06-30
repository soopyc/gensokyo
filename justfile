set unstable
set ignore-comments

# utility recipes
mod utils

sudo_cmd := "run0"

true := "true"
mkIf(k, v) := if k == true { v } else { "" }

# get help
help recipe="":
	#!/usr/bin/env sh
	if test "{{recipe}}" = ""; then
		just --list
		echo
		echo 'this justfile heavily utilizes nested `just` invocations,'
		echo 'there may be hidden params needed by the underlying recipe.'
		echo
		echo 'in general, see `just help (general|remote)`.'
	else
		just --usage {{recipe}}
		echo
		echo "some recipes may have additional help messages. if a help param exists, try passing --help."
	fi

# general nixos-rebuild operations, add -h for help
[arg("op", help="nixos-rebuild operations")]
[arg("system", short='s', long, help="the target system")]
[arg("nom", short='n', long="nom", value="true", help="use nix-output-monitor")]
[arg("sudo", long, value="true", help="use sudo")]
[arg("help", short='h', long, value="true", help="show help message")]
[arg("fast", long, value="true", help="add --no-reexec")]
[arg("args", long, help="args to pass to nixos-rebuild")]
[arg("extra-args", help="more args to pass to nixos-rebuild")]
general op system=`hostname` nom="" sudo="" help="" fast="" args="" *extra-args="":
	#!/usr/bin/env sh
	set -euo pipefail
	if test "{{help}}" = "true" || test {{op}} = "help"; then
		just --usage general
		echo
		echo 'op == ("help" OR any nixos-rebuild ops)'
		echo 'system defaults to the current host if not specified'
		exit 0
	fi

	set -x
	{{mkIf(sudo, sudo_cmd)}} nixos-rebuild \
		{{op}} \
		-v -L \
		--accept-flake-config \
		--flake ".#{{system}}" \
		{{args}}\
		{{extra-args}}\
		{{mkIf(fast, "--no-reexec")}}\
		{{mkIf(nom, "--log-format internal-json |& nom --json")}}

# do something to a remote
[arg("op", help="nixos-rebuild operations")]
[arg("system", help="the target system")]
[arg("remote-build", long, value="true", help="build on the remote")]
[arg("args", help="params passed to the general recipe")]
remote op system remote-build="" *args:
	just general {{op}} \
		--system {{system}} \
		--args " \
			--target-host {{system}} \
			--use-remote-sudo \
			{{mkIf(remote-build, f"--build-host {{system}}")}} \
		" \
		{{args}}

# eval a command on all systems matching a filter
[arg("help", short='h', long, value="true", help="show help message")]
[arg("cmd", help="a command, or `help`")]
[arg("filter", long, help="nix expression. see --help")]
[arg("fail-fast", short='F', long, value="true", help="fail and quit on first error")]
forall filter="true" help="" fail-fast="" +cmd="help":
	#!/usr/bin/env sh
	set -euo pipefail

	expr="configs: \
		builtins.map \
			(system: system.config.networking.hostName) \
			(builtins.filter \
				(system: {{filter}}) \
				(builtins.attrValues configs) \
			)"

	if test '{{cmd}}' = "help"; then
		just --usage forall
		echo
		echo '`filter` is a nix expression passed to `builtins.filter`.'
		echo 'a `system` parameter is provided, which contains the nixos config as accessed with .#nixosConfigurations.${system}.'
		echo '`--impure` is passed to `nix eval`, so things like `builtins.currentSystem` work.'
		echo
		echo '`cmd` can be any valid bash syntax to be run for all systems. the ${sys} env var is set to the current one.'
		exit
	fi

	echo "evaluating hosts matching filter..."
	systems=""
	read -r systems < <(nix eval --impure --json \
		--apply "${expr}" \
		'.#nixosConfigurations' \
		| jq '.[]' \
		| xargs
	)

	test "$systems" = "" && exit 1

	echo '{{GREEN}}will run the command{{NORMAL}}'
	echo '  {{CYAN}}{{cmd}}'
	echo
	echo '{{GREEN}}for the following systems:'
	for system in $systems; do echo "  * $system"; done

	printf '{{NORMAL}}continue? [Y/n] '
	read -r continue
	case $continue in
		''|y*|Y*) echo '{{GREEN}}continuing...{{NORMAL}}' ;;
			*) echo '{{RED}}aborted.{{NORMAL}}'; exit 1 ;;
	esac

	# status report
	stat_success="$(mktemp)"
	stat_fail="$(mktemp)"
	cleanup() {
		echo "{{GREEN}}* success:$(< $stat_success)"
		echo "{{RED}}* failure:$(< $stat_fail)"
		echo "{{NORMAL}}"
		rm $stat_success $stat_fail
	}
	trap cleanup EXIT ERR

	for sys in $systems; do
		set +e
		{{cmd}}

		exit="$?"
		test "$exit" -eq 130 && exit 1 # immediate exit on sigint/^C
		set -e

		if [ "$exit" -ne 0 ]; then
			if [ '{{fail-fast}}' = 'true' ]; then
				echo "{{RED}} fail-fast requested, terminating{{NORMAL}}"
				exit "$exit"
			else
				printf " ${sys}" >> $stat_fail
			fi
		else
			printf " ${sys}" >> $stat_success
		fi

		echo "------------------------ >8 -----------------------"
	done

# evaluate a system's configuration
[arg("system", short='s', long, help="the target system")]
eval system=`hostname` *args:
	nix eval '.#nixosConfigurations.{{system}}.config.system.build.toplevel' {{args}}

# build the configuration for a system
build *args="--nom":
	just general "build" {{args}}

# build the configuration for the current system
[default]
_build:
	just general "build" --nom -- --keep-going
	dix /run/current-system ./result

# switch the system to a configuration
switch *args:
	just general "switch" {{args}}

# switch but quick, quickswitch, sw
sw:
	just general "switch" --fast --sudo

# stage a configuration to a reboot
[arg("remote", short='r', long, value="true")]
stage remote="" *args:
	just {{ if remote == true {"remote"} else {"general"} }} "boot" {{args}}

# deploy to a remote machine
deploy *args:
	just remote "switch" {{args}}

[arg("boot", short='b', long, value="true", help="run the bootloader as well")]
[arg("run", short='r', long, value="true", help="run the vm after building")]
[arg("system", short='s', long, help="the target system")]
vm system=`hostname` boot="" run="" *args:
	just general "build-vm{{mkIf(boot, "-with-bootloader")}}" \
		--system {{system}} \
		{{args}}

	{{mkIf(run, f"./result/bin/run-{{system}}-vm")}}

# common filters
filterCurrentSystem := "system.config.nixpkgs.hostPlatform.system == builtins.currentSystem"
filterNonSensitive := "!system.config.gensokyo.traits.sensitive"

# evaluate all systems
# eval-all: (forall "true" "" "true" "just eval -s ${sys}")
eval-all:
	just forall -F 'just eval -s ${sys}'
build-all:
	just forall -F --filter '{{filterCurrentSystem}}' 'just build -s ${sys}'
# stage-all:
# deploy-all:
# build and cache systems
cache-all:
	# TODO: fix remote building so we can build for everything
	just forall --filter '{{filterCurrentSystem}}' \
		'just build -s ${sys} && niks3 push --pin gensokyo-${sys} ./result'

# non-nixos-rebuild stuff

# delete old nixos generations and GC the store
[arg("days", help="only delete generations older than this many days")]
gc days="3":
	{{sudo_cmd}} nix profile wipe-history \
		--profile /nix/var/nix/profiles/system \
		--older-than {{days}}d

	{{sudo_cmd}} nix store gc -vL

# run flake checks
check:
	nix flake check

# diff the current system and the one in ./result
diff:
	dix /run/current-system ./result

# update everything in flake.lock and commit
flake-update:
	nix flake update --commit-lock-file

