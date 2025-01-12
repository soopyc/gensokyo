# Todo Items
- [x] **!important** flatten nixosSystem definitions
	- instead of `import ./systems/stuff {}` do `nixosSystem = {...; imports = [./systems/stuff]}`

- [ ] migrate firewall to nftables
	- [ ] setup ipsets and block known abusers
<!-- - [ ] setup autoUpgrade -->
- [ ] migrate ~/.yubico/authorized_yubikeys to HM config (via pam.yubico.authorizedYubiKeys.ids)

- [-] fcitx5
	- [x] enable and configure basic fcitx5 stuff
	- [ ] migrate rime config to HM
- [x] arrpc

- one of
	- [ ] setup port knocking/fwknop
		- [ ] shield sshd behind fwknop
	- [ ] wireguard

<!-- very future tasks -->
- [ ] migrate to a configuration where [erase your darlings](https://grahamc.com/blog/erase-your-darlings/) is possible

<!-- ## Completed Tasks -->
- [x] setup patchouli
- [x] setup vaultwarden
