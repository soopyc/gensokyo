{...}: {
  programs.atuin = {
    enable = true;
    daemon.enable = true;
    settings = {
      search_mode = "prefix";
      update_check = false;
      workspaces = true;
      sync_address = "https://atuin.soopy.moe";

      sync.records = true;
    };
  };
}
