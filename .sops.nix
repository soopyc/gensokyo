let
  # maintainers
  age.soopyc_pxl7ag = "age1l3qxt6630dzesdclfm3eqgw3uuhwj09dh6typwlwr6clcv0qhfrqgtj2fk";
  # age.soopyc_yub302 = "age1yubikey1qgmfcf0vddslyza7djdekjjk3t3u29d474c5xscmcdye8x3spvhlxxj23xz";
  pgp.soopyc_yub302 = "8F3B277901484C6EA7E63F82D539637D518022C6";

  # hosts
  age.koumakan = "age18h7hya5terghrwawgpny28swlat2nqkdrfd4clk0svujqlz9xfusd3zeqt";

  everything = [
    {
      age = builtins.attrValues age;
      pgp = builtins.attrValues pgp;
    }
  ];
in {
  # remember to run `just utils update-sops-config` and `sops updatekeys` after editing.
  creation_rules = [
    {
      path_regex = "creds/sops/global/.*";
      key_groups = everything;
    }

    {
      path_regex = "creds/sops/koumakan/.*";
      key_groups = [
        {
          age = with age; [
            soopyc_pxl7ag
            # soopyc_yub302
            koumakan
          ];
          pgp = [pgp.soopyc_yub302];
        }
      ];
    }
  ];
}
