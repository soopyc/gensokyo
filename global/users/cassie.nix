{...}: {
  users.users.cassie = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    openssh = {
      authorizedKeys.keyFiles = [../../creds/ssh/cassie];
    };
    # packages = with pkgs; [];
  };
}
