let
  # Generates Mod+1..9 and Mod+Shift+1..9
  workspaceBinds = builtins.listToAttrs (builtins.concatMap (i:
    let key = toString i;
    in [
      {
        name = "Mod+${key}";
        value.action.focus-workspace = i;
      }
      {
        name = "Mod+Shift+${key}";
        value.action.move-column-to-workspace = i;
      }
    ]) (builtins.genList (x: x + 1) 9));
in { pkgs, ... }: {
  home.username = "shinobu";
  home.homeDirectory = "/home/shinobu";
  home.stateVersion = "25.11";

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Matheus Filipe dos Santos Reinert";
        email = "matheus.reinert@protonmail.com";
      };
      init.defaultBranch = "main";
    };
  };

  home.sessionVariables = {
    GOPATH = "$HOME/.go";
    QT_QPA_PLATFORM = "wayland;xcb";
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1"; # Firefox Wayland support
    SDL_VIDEODRIVER = "wayland,x11"; # Games/SDL apps
    _JAVA_AWT_WM_NONREPARENTING = "1"; # Fixes blank windows in Java apps
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
  };

  nixpkgs.config.allowUnfree = true;

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };

  gtk = {
    enable = true;
    font = {
      name = "Lexed Deca";
      size = 12;
    };
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    iconTheme = {
      name = "Dracula";
      package = pkgs.dracula-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        margin-top = 4;
        position = "top";
        modules-left = [ "niri/workspaces" "pulseaudio" "temperature" ];
        modules-center = [ "niri/window" ];
        modules-right = [ "cpu" "memory" "battery" "clock" ];
        "niri/window" = {
          separate-outputs = true;
          max-length = 40;
        };
        "pulseaudio" = {
          format = ''<span size="large" rise="-1pt">{icon}</span>  {volume}%'';
          format-muted = "󰝟";
          format-icons = { default = [ "󰕿" "󰖀" "󰕾" ]; };
        };
        "cpu" = {
          interval = 1;
          format = ''<span size="large" rise="-1pt"></span>  {usage}%'';
        };
        "temperature" = {
          critical-threshold = 80;
          format = "{icon} {temperatureC}°C";
          format-icons = [ "" "" "" "" "" ];
        };
        "memory" = {
          interval = 5;
          format = "  {used:0.1f}G";
        };
        "battery" = {
          format = ''<span size="large" rise="-1pt">{icon}</span> {capacity}%'';
          format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
          format-charging =
            ''<span size="large" rise="-1pt">󰂅</span>  {capacity}%'';
        };
        "backlight" = {
          format = ''<span size="large" rise="-1pt">{icon}</span>  {percent}%'';
          format-icons = [ "󰃚" "󰃛" "󰃜" "󰃝" "󰃞" "󰃟" "󰃠" ];
        };
        "network" = {
          format-wifi = ''<span size="large" rise="-1pt"></span>  {essid}'';
          max-length = 12;
        };
        "clock" = {
          format = ''<span size="large" rise="-1pt"></span>  {:%H:%M}'';
        };
      };
    };
    style = ''
      @define-color background #282a36;
      @define-color foreground #f8f8f2;
      @define-color grey #44475a;
      @define-color yellow #f1fa8c;
      @define-color blue #6272a4;
      @define-color cyan #8be9fd;
      @define-color green #50fa7b;
      @define-color orange #ffb86c;
      @define-color pink #ff79c6;
      @define-color purple #bd93f9;
      @define-color red #ff5555;

      window#waybar {
        opacity: 1;
        background: transparent;
        font-family: "Lexend Deca", "Symbols Nerd Font";
        font-size: 16px;
      }

      /* Niri Workspaces */
      #workspaces {
        background-color: @purple;
        border-radius: 20px;
        margin: 0 5px;
      }

      #workspaces button {
        padding: 0 8px;
        color: @foreground;
        border-radius: 20px;
      }

      /* Niri uses .active instead of .focused */
      #workspaces button.active {
        color: @green;
      }

      #workspaces button.urgent {
        animation-duration: 0.5s;
        animation-name: blink;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
        color: @red;
      }

      @keyframes blink { to { color: @foreground; } }

      /* Niri Window */
      #window {
        border-right: 10px solid @red;
        border-left: 10px solid @red;
        border-radius: 20px;
        background-color: @red;
        color: @foreground;
      }

      /* Common module styling */
      #cpu, 
      #pulseaudio, 
      #battery, 
      #backlight, 
      #network, 
      #clock, 
      #temperature, 
      #memory {
        padding: 0 5px;
        margin: 0 5px;
        border-radius: 20px;
      }


      #cpu { border-left: 10px solid @background; border-right: 10px solid @background; background-color: @background; }
      #memory { border-left: 10px solid @grey; border-right: 10px solid @grey; background-color: @grey; }
      #battery { border-left: 10px solid @blue; border-right: 10px solid @blue; background-color: @blue; }
      #pulseaudio, #backlight { border-left: 10px solid @orange; border-right: 10px solid @orange; background-color: @orange; }
      #network { border-left: 10px solid @pink; border-right: 10px solid @pink; background-color: @pink; }
      #clock { border-left: 10px solid @purple; border-right: 10px solid @purple; background-color: @purple; }
      #temperature { border-left: 10px solid @pink; border-right: 10px solid @pink; background-color: @pink; }
    '';

  };

  programs.niri.settings = {
    prefer-no-csd = true;
    spawn-at-startup = [
      { argv = [ "${pkgs.vesktop}/bin/vesktop" ]; }
      { argv = [ "${pkgs.waybar}/bin/waybar" ]; }
      { argv = [ "${pkgs.mako}/bin/mako" ]; }
      {
        argv = [''
          spawn-at-startup "dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        ''];
      }
      {
        argv = [
          "${pkgs.swaybg}/bin/swaybg"
          "-m"
          "fill"
          "-i"
          "/home/shinobu/Pictures/wallpaper.jpg"
        ];
      }
    ];
    gestures = { hot-corners.enable = false; };
    workspaces = { "chats" = { open-on-output = "DP-2"; }; };
    window-rules = [
      {
        open-maximized = true;
        clip-to-geometry = true;
        geometry-corner-radius = {
          bottom-left = 8.0;
          bottom-right = 8.0;
          top-left = 8.0;
          top-right = 8.0;
        };
      }
      {
        matches = [ { app-id = "zapzap"; } { app-id = "vesktop"; } ];
        open-focused = false;
        open-on-workspace = "chats";
      }
    ];
    input = {
      keyboard = {
        xkb = {
          layout = "us";
          variant = "intl";
        };
      };
      mouse = {
        accel-speed = 0.0;
        accel-profile = "flat";
      };
    };
    layout = {
      gaps = 8;
      center-focused-column = "never";
      preset-column-widths = [
        { proportion = 1.0 / 3.0; }
        { proportion = 1.0 / 2.0; }
        { proportion = 2.0 / 3.0; }
      ];
      border.enable = false;
      focus-ring = {
        enable = true;
        width = 2;
        active.color = "#50fa7b";
        inactive.color = "#bd93f9";
      };
    };
    binds = workspaceBinds // {
      "Mod+Ctrl+Shift+H".action.move-column-to-monitor-left = [ ];
      "Mod+Ctrl+Shift+L".action.move-column-to-monitor-right = [ ];
      "Mod+C".action.focus-workspace = "chats";
      "Mod+Shift+C".action.move-column-to-workspace = "chats";
      "Mod+Return".action.spawn = "alacritty";
      "Mod+R".action.spawn = "fuzzel";
      "Mod+Ctrl+H".action.focus-monitor-left = [ ];
      "Mod+Ctrl+L".action.focus-monitor-right = [ ];
      "Mod+Shift+Left".action.move-column-to-monitor-left = [ ];
      "Mod+Shift+Right".action.move-column-to-monitor-right = [ ];
      "Mod+H".action.focus-column-left = [ ];
      "Mod+L".action.focus-column-right = [ ];
      "Mod+K".action.focus-window-or-workspace-up = [ ];
      "Mod+J".action.focus-window-or-workspace-down = [ ];
      "Mod+Shift+H".action.move-column-left = [ ];
      "Mod+Shift+L".action.move-column-right = [ ];
      "Mod+Shift+J".action.move-window-down-or-to-workspace-down = [ ];
      "Mod+Shift+K".action.move-window-up-or-to-workspace-up =
        [ ]; # Fixed 'down' typo from your snippet
      "Mod+W".action.close-window = [ ];
      "Mod+Ctrl+W".action.quit.skip-confirmation = true;
      "Mod+F".action.maximize-column = [ ];
    };
    outputs = {
      "DP-1" = {
        mode = {
          width = 1920;
          height = 1080;
          refresh = 144.0;
        };
        position = {
          x = 3840;
          y = 0;
        };
      };
      "DP-2" = {
        mode = {
          width = 1920;
          height = 1080;
          refresh = 60.0;
        };
        position = {
          x = 0;
          y = 0;
        };
      };
      "DP-3" = {
        focus-at-startup = true;
        mode = {
          width = 1920;
          height = 1080;
          refresh = 144.0;
        };
        position = {
          x = 1920;
          y = 0;
        };
      };
    };
  };

  # --- Alacritty ---
  programs.alacritty = {
    enable = true;
    settings = {
      general.import = [ pkgs.alacritty-theme.dracula ];
      font = {
        size = 14.0;
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
      };
      terminal.shell = {
        program = "${pkgs.zsh}/bin/zsh";
        args = [ "-l" "-c" "tmux" ];
      };
    };
  };

  programs.zsh = {
    enable = true;
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "zsh-vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
    ];
    initContent = ''
      zstyle ':completion:*' completer _expand _complete _ignored
      zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:]}={[:upper:]}'
      zstyle ":completion:*:commands" rehash 1
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      alias ls='exa --icons'
      export EDITOR=nvim
    '';
  };

  programs.tmux = {
    enable = true;
    mouse = true;
    keyMode = "vi";
    baseIndex = 1;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      resurrect
      continuum
      {
        plugin = dracula;
        extraConfig = ''
          set -g @dracula-show-battery false
          set -g @dracula-show-powerline true
          set -g @dracula-refresh-rate 10
        '';
      }
    ];
    extraConfig = "set-option -g status-position top";
  };
}
