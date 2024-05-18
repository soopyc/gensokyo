# `_utils.mkArionProject`
`(lambda: freeformAttrset) -> freeformAttrset`

Flattened Arion project configuration

## Example
```nix
{_utils, ...}: {
	virtualisation.arion.projects."cop" = _utils.mkArionProject (config': {
		networks.main.enable_ipv6 = true;
	});
}
```

See <https://docs.hercules-ci.com/arion/options> for more information.
