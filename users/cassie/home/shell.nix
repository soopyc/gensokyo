{ ... }:
{
  programs.atuin = {
    enable = true;
    daemon.enable = true;
    settings = {
      search_mode = "fuzzy";
      update_check = false;
      workspaces = true;
      sync_address = "https://atuin.soopy.moe";
      search_mode_shell_up_key_binding = "prefix";
      filter_mode_shell_up_key_binding = "session";
      enter_accept = true;
      inline_height = 10;

      daemon.sync_frequency = 10;
      sync.records = true;

      stats.common_subcommands = [
        ","
        "apt"
        "cargo"
        "composer"
        "dnf"
        "docker"
        "git"
        "go"
        "ip"
        "just"
        "kubectl"
        "nix"
        "nmcli"
        "npm"
        "pecl"
        "pnpm"
        "podman"
        "port"
        "systemctl"
        "tmux"
        "yarn"
      ];

      # FUCK. OFF. FUCK OFF FUCK OFF FUCK OFF FUCK OFF
      # I don't need your STUPID FUCKING AI
      # GO SHOVE YOUR SLOP GENERATOR ANYWHERE ELSE
      # I KNOW WHAT I AM DOING AND I DON'T NEED A STUPID FUCKING ALGORITHM TELLING ME WHAT TO DO
      # WHAT I TYPE IS NONE OF YOUR FUCKING BUSINESS
      # STOP FORCING ME TO USE BRAINLESS SHIT
      # I AM SO FUCKING DONE
      # ** THIS DOES NOT FUCKING NEED TO BE ENABLED BY DEFAULT **
      # ** NOR SHOULD I BE ASKED TO USE YOUR DOGSHIT AI IF I DIDN'T SET IT **
      ai.enable = false;
    };
  };
}
