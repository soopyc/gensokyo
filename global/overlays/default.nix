inputs: [
  inputs.mystia.overlays.default
  # (final: prev: {
  #   vencord = prev.vencord.overrideAttrs (final': {
  #     version = "1.12.1";
  #     src = final.fetchFromGitHub {
  #       owner = "Vendicated";
  #       repo = "Vencord";
  #       tag = "v${final'.version}";
  #       hash = "sha256-Vs6S8N3q5JzXfeogfD0JrVIhMnYIio7+Dfy12gUJrlU=";
  #     };
  #   });
  # })
]
