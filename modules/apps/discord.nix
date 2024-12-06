{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    vencord
  ];

  # Add Vencord settings through XDG config
  xdg.configFile."Vencord/settings.json".text = ''
    {
      "themeLinks": [
        "https://raw.githubusercontent.com/catppuccin/discord/main/themes/mocha-mauve.theme.css"
      ]
    }
  '';
} 