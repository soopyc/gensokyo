let
  # maintainers
  age.soopyc_pxl7ag = "age1l3qxt6630dzesdclfm3eqgw3uuhwj09dh6typwlwr6clcv0qhfrqgtj2fk";
  # age.soopyc_yub302 = "age1yubikey1qgmfcf0vddslyza7djdekjjk3t3u29d474c5xscmcdye8x3spvhlxxj23xz";
  age.soopyc_mbp14 = "age1zkafenrdkkmatjh034yykpzjzzs5fx6kft23jlmsung3dwyufcksds59l2";

  # hosts
  age.koumakan = "age18h7hya5terghrwawgpny28swlat2nqkdrfd4clk0svujqlz9xfusd3zeqt";
  age.satori = "age132qsqclmp5d6x968x5y8amdn90v64rldy3assprr8g8wjdpecvmqwryah8";
  age.renko = "age1p6n5yh9fy09xspwf29klfsa4zdrhp04q22gvxkz2vvm88vt9tunsdn020s";
  age.bocchi = "age1kdctxllje2rw3kwpzell0rt6t7mruc3h3j5zfjelnpmahchjlaqs9v9vm9";
  age.kita = "age1qzma7prftj6d4atqcmatdl9le0tuuqzegm6f8e9gkwrp3pja0aaqs49g7n";
  age.ryo = "age1tdatk0rrr6uf89g5vpq96wjcjcetkrs6yadkxv47v76q8qhtva2sn7tun2";
  age.nijika = "age1rzxugsgkpnf0ns0w70swdc3sndjpktx23eucah4w47zcppz56sls2c5e6m";

  everything = [
    {
      age = builtins.attrValues age;
    }
  ];

  mkHost = name: identities:
    assert builtins.typeOf identities == "list"; {
      path_regex = "creds/sops/${name}/.*";
      key_groups = [
        {
          age =
            [
              # admin
              age.soopyc_pxl7ag
              age.soopyc_mbp14
            ]
            ++ identities;
        }
      ];
    };
in {
  # remember to run `just utils update-sops-config` and `sops updatekeys` after editing.
  creation_rules = [
    {
      path_regex = "creds/sops/global/.*";
      key_groups = everything;
    }

    (mkHost "koumakan" [age.koumakan])
    (mkHost "satori" [age.satori])
    (mkHost "renko" [age.renko])

    (mkHost "bocchi" [age.bocchi])
    (mkHost "kita" [age.kita])
    (mkHost "ryo" [age.ryo])
    (mkHost "nijika" [age.nijika])
  ];
}
