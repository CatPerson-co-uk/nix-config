{config, pkgs, lib, ...}:

{
  # Add fonts
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    font-awesome
  ];

  # Add systemd user service for monitor rotation
  systemd.user.services.rotate-monitor = {
    Unit = {
      Description = "Rotate HDMI-1 monitor";
      After = ["graphical-session-pre.target"];
      PartOf = ["graphical-session.target"];
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.xorg.xrandr}/bin/xrandr --output HDMI-0 --rotate right";
      RemainAfterExit = true;
    };

    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };

  xsession = {
    enable = true;
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3;
      config = {
        modifier = "Mod4";  # Use Windows/Super key as modifier
        terminal = "kitty";
        
        # Initialize workspaces
        workspaceOutputAssign = [
          { workspace = "1"; output = "primary"; }
          { workspace = "2"; output = "primary"; }
          { workspace = "3"; output = "primary"; }
          { workspace = "4"; output = "primary"; }
          { workspace = "5"; output = "primary"; }
        ];

        # Catppuccin Mocha colors
        colors = {
          focused = {
            border = "#cba6f7";      # Mauve
            background = "#cba6f7";
            text = "#1e1e2e";        # Base
            indicator = "#f5e0dc";    # Rosewater
            childBorder = "#cba6f7";
          };
          
          unfocused = {
            border = "#313244";       # Surface0
            background = "#313244";
            text = "#cdd6f4";        # Text
            indicator = "#313244";
            childBorder = "#313244";
          };
          
          focusedInactive = {
            border = "#45475a";       # Surface1
            background = "#45475a";
            text = "#cdd6f4";        # Text
            indicator = "#45475a";
            childBorder = "#45475a";
          };
          
          urgent = {
            border = "#f38ba8";       # Red
            background = "#f38ba8";
            text = "#1e1e2e";        # Base
            indicator = "#f38ba8";
            childBorder = "#f38ba8";
          };
        };
        
        # Add gaps and border styling
        gaps = {
          inner = 8;
          outer = 4;
        };
        
        window.border = 2;
        
        # Key bindings
        keybindings = let
          modifier = "Mod4";
        in {
          # Workspace keybindings
          "${modifier}+1" = "workspace number 1";
          "${modifier}+2" = "workspace number 2";
          "${modifier}+3" = "workspace number 3";
          "${modifier}+4" = "workspace number 4";
          "${modifier}+5" = "workspace number 5";
          
          "${modifier}+Shift+1" = "move container to workspace number 1";
          "${modifier}+Shift+2" = "move container to workspace number 2";
          "${modifier}+Shift+3" = "move container to workspace number 3";
          "${modifier}+Shift+4" = "move container to workspace number 4";
          "${modifier}+Shift+5" = "move container to workspace number 5";

          # Basic keybindings
          "${modifier}+Return" = "exec ${pkgs.kitty}/bin/kitty";
          "${modifier}+Shift+q" = "kill";
          "${modifier}+d" = "exec ${pkgs.dmenu}/bin/dmenu_run";
          
          # Change focus
          "${modifier}+h" = "focus left";
          "${modifier}+j" = "focus down";
          "${modifier}+k" = "focus up";
          "${modifier}+l" = "focus right";
          
          # Move windows
          "${modifier}+Shift+h" = "move left";
          "${modifier}+Shift+j" = "move down";
          "${modifier}+Shift+k" = "move up";
          "${modifier}+Shift+l" = "move right";
          
          # Layouts
          "${modifier}+s" = "layout stacking";
          "${modifier}+w" = "layout tabbed";
          "${modifier}+e" = "layout toggle split";
          
          # Fullscreen
          "${modifier}+f" = "fullscreen toggle";
          
          # Restart/reload i3
          "${modifier}+Shift+c" = "reload";
          "${modifier}+Shift+r" = "restart";
          "${modifier}+Shift+e" = "exit";
        };

        bars = [];  # This disables the i3 bar
        
        # Startup applications
        startup = [
          {
            command = "i3-msg 'workspace 1'";
            always = false;
            notification = false;
          }
          {
            command = "eww open bar";
            always = true;
            notification = false;
          }
          {
            command = "${pkgs.picom}/bin/picom -b --config ~/.config/picom/picom.conf";
            always = true;
            notification = false;
          }
        ];
      };
    };
  };

  # Add picom configuration
  home.file.".config/picom/picom.conf".text = ''
    backend = "glx";
    vsync = true;
    
    # Shadows
    shadow = true;
    shadow-radius = 12;
    shadow-opacity = 0.75;
    shadow-offset-x = -12;
    shadow-offset-y = -12;
    
    # Fading
    fading = true;
    fade-in-step = 0.03;
    fade-out-step = 0.03;
    
    # Corners
    corner-radius = 12;
    rounded-corners-exclude = [
      "class_g = 'i3bar'",
      "class_g = 'dmenu'",
      "window_type = 'dock'",
      "window_type = 'desktop'",
      "window_type = 'toolbar'",
      "window_type = 'menu'",
      "window_type = 'dropdown_menu'",
      "window_type = 'popup_menu'",
      "window_type = 'tooltip'",
      "window_type = 'notification'",
      "window_type = 'combo'",
      "window_type = 'dialog'",
      # Exclude i3 windows in tabbed/stacked mode
      "class_g = 'i3' && window_type = 'normal' && I3_FLOATING_WINDOW@:c != 1 && I3_FRAME_GAPS@:c = 0"
    ];
    
    # Transparency
    inactive-opacity = 1.0;
    active-opacity = 1.0;
    frame-opacity = 1.0;
    inactive-opacity-override = false;
    
    # Blur
    blur-background = true;
    blur-method = "dual_kawase";
    blur-strength = 3;
  '';
} 