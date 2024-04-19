{...}: {
  users.users.cassie = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    openssh = {
      authorizedKeys.keyFiles = [../../creds/ssh/cassie];
    };
  };

  home-manager.users.cassie = import ./home;
}
