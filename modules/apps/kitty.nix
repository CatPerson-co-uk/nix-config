{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
   
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };
    settings = {
      # Window
      window_padding_width = 4;
      hide_window_decorations = "yes";
      confirm_os_window_close = 0;

      # Tabs
      tab_bar_edge = "bottom";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_title_template = "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";

      # Catppuccin Mocha Colors
      foreground = "#cdd6f4";
      background = "#1e1e2e";
      selection_foreground = "#1e1e2e";
      selection_background = "#f5e0dc";

      # Cursor
      cursor_shape = "beam";
      cursor = "#f5e0dc";
      cursor_beam_thickness = "1.5";

      # URL
      url_color = "#f5e0dc";
      url_style = "curly";

      # Window borders
      active_border_color = "#cba6f7";
      inactive_border_color = "#45475a";
      bell_border_color = "#f9e2af";

      # Tabs
      active_tab_foreground = "#1e1e2e";
      active_tab_background = "#cba6f7";
      inactive_tab_foreground = "#cdd6f4";
      inactive_tab_background = "#181825";
      tab_bar_background = "#1e1e2e";

      # Colors
      color0 = "#45475a";  # surface1
      color8 = "#585b70";  # surface2
      color1 = "#f38ba8";  # red
      color9 = "#f38ba8";  # red
      color2 = "#a6e3a1";  # green
      color10 = "#a6e3a1"; # green
      color3 = "#f9e2af";  # yellow
      color11 = "#f9e2af"; # yellow
      color4 = "#89b4fa";  # blue
      color12 = "#89b4fa"; # blue
      color5 = "#f5c2e7";  # pink
      color13 = "#f5c2e7"; # pink
      color6 = "#94e2d5";  # teal
      color14 = "#94e2d5"; # teal
      color7 = "#bac2de";  # subtext1
      color15 = "#a6adc8"; # subtext0
    };
  };
} 