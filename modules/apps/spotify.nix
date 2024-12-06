{ config, pkgs, ... }:

{
  # Add Spotify to packages
  home.packages = with pkgs; [
    spotify
  ];
} 