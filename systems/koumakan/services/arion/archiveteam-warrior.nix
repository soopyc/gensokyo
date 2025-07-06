{
  virtualisation.oci-containers.containers.at-warrior = {
    image = "atdr.meo.ws/archiveteam/warrior-dockerfile";
    ports = [ "100.100.16.16:35842:8001" ];

    labels = {
      "io.containers.autoupdate" = "registry";
    };

    environment = {
      DOWNLOADER = "soopyc";
      WARRIOR_ID = "soopyc-uSoU1YZC";
      CONCURRENT_ITEMS = "3";
    };
  };
}
