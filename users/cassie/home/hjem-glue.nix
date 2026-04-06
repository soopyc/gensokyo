{ osConfig, lib, ... }:
{
  # temporary glue code for hjem, will be replaced when HM is fully removed.
  # TODO: remove, and replace all instances of "hjem-zsh-glue.zsh" with just .zshrc
  programs.zsh.initContent = lib.mkAfter ''
    source ${osConfig.hjem.users.cassie.environment.loadEnv}
    source ${osConfig.hjem.users.cassie.xdg.config.files."hjem-zsh-glue.zsh".target}
  '';
}
