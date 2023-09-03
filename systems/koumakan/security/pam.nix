{...}: {
  security.pam.yubico = {
    enable = true;
    id = builtins.readFile ./ykid.cry;
    mode = "client";
    control = "requisite";
  };

  security.pam.services = {
    sudo.yubicoAuth = true;
  };
}
