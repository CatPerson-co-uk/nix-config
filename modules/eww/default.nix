{config, pkgs, lib, ...}:

{
  home.packages = with pkgs; [
    eww
    pamixer # For volume control
    brightnessctl # For brightness control
    jq # For JSON parsing
    socat # For socket communication
    networkmanager # For network info
  ];

  # Create eww config directory
  xdg.configFile."eww" = {
    source = ./config;
    recursive = true;
  };
} 