{
  imports = [
    ./hjem
  ];

  users.users.cassie = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "dialout" # esp programming
    ];
    openssh = {
      authorizedKeys.keyFiles = [ ../../creds/ssh/users/cassie ];
    };
  };

  home-manager.users.cassie = import ./home;
}
