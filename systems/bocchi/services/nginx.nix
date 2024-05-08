# we could make this into a presets system
{...}: {
  gensokyo.presets.nginx = true;

  services.nginx = {
    enable = true;
    clientMaxBodySize = "5m";
  };
}
