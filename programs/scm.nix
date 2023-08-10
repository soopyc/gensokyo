{ ... }: 
{
  programs.git = {
    enable = true;
    config = {
      init.defaultBranch = "main";
    };
  };
}
