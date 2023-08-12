{ pkgs, ... }: 
{
  # Set default i18n configuration
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Lock root account
  users.users.root.shell = pkgs.shadow;  # basically /bin/nologin
}
