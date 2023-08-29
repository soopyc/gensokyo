{ pkgs, ... }:

{
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    substituters = [
      "https://nonbunary.soopy.moe/gensokyo-koumakan"
      "https://nonbunary.soopy.moe/gensokyo-satori"
      "https://nonbunary.soopy.moe/gensokyo-global"
    ];

    trusted-substituters = [
      "https://nonbunary.soopy.moe/gensokyo-koumakan"
      "https://nonbunary.soopy.moe/gensokyo-satori"
      "https://nonbunary.soopy.moe/gensokyo-global"
    ];

    trusted-public-keys = [
      "gensokyo-koumakan:ODEzVQdQ7UEHvPsLWYn7wxN//xS/0lkhjHgfkZlxO4k="
      "gensokyo-satori:dAbXCUMJP2GZfviFA+yD4+dsxedMqMweOjecAM/zfKk="
      "gensokyo-global:XiCN0D2XeSxF4urFYTprR+1Nr/5hWyydcETwZtPG6Ec="
    ];

    fallback = true;
    connect-timeout = 30;
    max-jobs = "auto";
    auto-optimise-store = true;
  };

  nix.package = pkgs.nixFlakes;
}
