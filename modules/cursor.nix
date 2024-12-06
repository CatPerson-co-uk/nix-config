{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    catppuccin-cursors.mochaMauve
  ];

  home.pointerCursor = {
    package = pkgs.catppuccin-cursors.mochaMauve;
    name = "Catppuccin-Mocha-Mauve-Cursors";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # Ensure cursor theme is applied for GTK applications
  gtk = {
    enable = true;
    cursorTheme = {
      name = "Catppuccin-Mocha-Mauve-Cursors";
      package = pkgs.catppuccin-cursors.mochaMauve;
      size = 24;
    };
  };
} 