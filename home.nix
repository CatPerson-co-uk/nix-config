{ config, pkgs, lib, ... }:

{
  imports = [ 
    ./modules/apps/spotify.nix
    ./modules/apps/discord.nix
    ./modules/apps/kitty.nix
    ./modules/i3
    ./modules/eww
    ./modules/private.nix
  ];

  home.username = "catperson";
  home.homeDirectory = "/home/catperson";

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  # Add ~/.local/bin to PATH
  home.sessionPath = [ "$HOME/.local/bin" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Your existing bash configuration
  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      rebuild = "cd ~/nix-config && sudo nixos-rebuild switch --flake .#nixConfig && read -p 'Would you like to reboot now? (y/N) ' answer && [[ $answer == [Yy]* ]] && sudo reboot";
    };
  };

  home.file.".local/share/applications/.keep".text = "";

  home.activation = {
    createApplicationsDirectory = lib.hm.dag.entryAfter ["writeBoundary"] ''
      mkdir -p $HOME/.local/share/applications
      chmod 755 $HOME/.local/share/applications
    '';
  };
}
