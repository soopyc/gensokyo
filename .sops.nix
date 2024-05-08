let
  # maintainers
  age.soopyc_pxl7ag = "age1l3qxt6630dzesdclfm3eqgw3uuhwj09dh6typwlwr6clcv0qhfrqgtj2fk";
  # age.soopyc_yub302 = "age1yubikey1qgmfcf0vddslyza7djdekjjk3t3u29d474c5xscmcdye8x3spvhlxxj23xz";
  age.soopyc_mbp14 = "age1zkafenrdkkmatjh034yykpzjzzs5fx6kft23jlmsung3dwyufcksds59l2";

  # hosts
  age.koumakan = "age18h7hya5terghrwawgpny28swlat2nqkdrfd4clk0svujqlz9xfusd3zeqt";
  age.satori = "age17sesmv0vs79gc0e2dm66feamph4h6xp4plyatwxkhupucnefnqlsvyk8m3";
  age.bocchi = "age1w7l663nmqq87e46893dngcy8uxpfeuxlp42a3ma0x4wyuxltjddsecy06p";

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

    (mkHost "bocchi" [age.bocchi])
  ];
}
