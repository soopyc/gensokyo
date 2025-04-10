{ ... }:
{
  security.pam.yubico = {
    enable = true;
    id = "91582";
    mode = "client";
    control = "requisite";
  };

  security.pam.services = {
    sudo.yubicoAuth = true;
  };
}
