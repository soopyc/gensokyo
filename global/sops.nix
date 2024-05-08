{
  hostname,
  inputs,
  ...
}: {
  sops.age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
  sops.defaultSopsFile = "${inputs.self}/creds/sops/${hostname}/default.yaml";
}
