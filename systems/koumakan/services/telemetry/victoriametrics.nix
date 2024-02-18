{...}: {
  services.victoriametrics = {
    enable = true;
    retentionPeriod = 5 * 12; # 5 years
  };

  # to setup capturing, please use systems.koumakan.administration.telemetry
}
