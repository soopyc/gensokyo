let
  # maintainers
  age.soopyc_pxl7ag = "age1l3qxt6630dzesdclfm3eqgw3uuhwj09dh6typwlwr6clcv0qhfrqgtj2fk";
  # age.soopyc_yub302 = "age1yubikey1qgmfcf0vddslyza7djdekjjk3t3u29d474c5xscmcdye8x3spvhlxxj23xz";
  age.soopyc_mbp14 = "age1zkafenrdkkmatjh034yykpzjzzs5fx6kft23jlmsung3dwyufcksds59l2";

  # hosts
  age.koumakan = "age18h7hya5terghrwawgpny28swlat2nqkdrfd4clk0svujqlz9xfusd3zeqt";
  age.satori = "age1ezx4f7szu3mf4e84de7vlw0aaxshfr3tjt6dm356g578ujkck9mqy6ff8v";
  age.bocchi = "age1kdctxllje2rw3kwpzell0rt6t7mruc3h3j5zfjelnpmahchjlaqs9v9vm9";
  age.renko = "age1p6n5yh9fy09xspwf29klfsa4zdrhp04q22gvxkz2vvm88vt9tunsdn020s";
  age.kita = "age1qzma7prftj6d4atqcmatdl9le0tuuqzegm6f8e9gkwrp3pja0aaqs49g7n";

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
  ];
}
