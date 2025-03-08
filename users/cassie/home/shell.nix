{...}: {
  programs.atuin = {
    enable = true;
    daemon.enable = true;
    settings = {
      search_mode = "prefix";
      update_check = false;
      workspaces = true;
      sync_address = "https://atuin.soopy.moe";
      filter_mode = "session";
      enter_accept = true;
      inline_height = 10;

      daemon.sync_frequency = 10;
      sync.records = true;
    };
  };
}
