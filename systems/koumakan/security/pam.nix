{ ... }:
{
  security.pam.yubico = {
    enable = true;
    id = builtins.readFile ./ykid.cry;
    mode = "client";
    #control = "requisite";  # TODO: uncomment if it works
  };

  security.pam.services = {
    sudo.yubicoAuth = true;
  };
}
