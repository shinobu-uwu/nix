let
  # Generates Mod+1..9 and Mod+Shift+1..9
  workspaceBinds = builtins.listToAttrs (
    builtins.concatMap (
      i: let
        key = toString i;
      in [
        {
          name = "Mod+${key}";
          value.action.focus-workspace = i;
        }
        {
          name = "Mod+Shift+${key}";
          value.action.move-column-to-workspace = i;
        }
      ]
    ) (builtins.genList (x: x + 1) 9)
  );
in
  {
    inputs,
    pkgs,
    lib,
    ...
  }: let
    noctalia = pkgs.callPackage (inputs.noctalia + "/nix/package.nix") {};
  in {
    programs.niri.settings = {
      prefer-no-csd = true;
      spawn-at-startup = [
        {
          argv = [
            "dbus-update-activation-environment"
            "--systemd"
            "DISPLAY"
            "WAYLAND_DISPLAY"
            "XDG_CURRENT_DESKTOP"
          ];
        }
        {
          argv = ["vesktop"];
        }
      ];
      gestures = {
        hot-corners.enable = false;
      };
      workspaces = {
        "chats" = {
          open-on-output = "DP-2";
        };
      };

      blur = {
        passes = 2;
        offset = 3.0;
        noise = 0.03;
        saturation = 1.08;
      };

      layer-rules = [
        {
          matches = [
            {
              namespace = "^noctalia-(notification|osd).*";
            }
          ];
          background-effect = {
            blur = true;
            xray = false;
          };
        }
        {
          matches = [
            {
              namespace = "^noctalia-desktop-widget-.*";
            }
          ];
          background-effect = {
            blur = true;
            xray = false;
          };
        }
      ];

      window-rules = [
        {
          open-maximized = true;
          clip-to-geometry = true;
          background-effect = {
            blur = true;
            xray = false;
          };
          geometry-corner-radius = {
            bottom-left = 12.0;
            bottom-right = 12.0;
            top-left = 12.0;
            top-right = 12.0;
          };
        }
        {
          matches = [
            {app-id = "zapzap";}
            {app-id = "vesktop";}
          ];
          open-focused = false;
          open-on-workspace = "chats";
        }
        {
          matches = [{app-id = "taskforge";}];
          open-on-output = "DP-1";
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
          {proportion = 1.0 / 3.0;}
          {proportion = 1.0 / 2.0;}
          {proportion = 2.0 / 3.0;}
        ];
        border.enable = false;
        focus-ring = {
          enable = true;
          width = 2;
          active.color = "#8fbdb5";
          inactive.color = "#353b50";
        };
      };
      binds =
        workspaceBinds
        // {
          "Mod+Ctrl+Shift+H".action.move-column-to-monitor-left = [];
          "Mod+Ctrl+Shift+L".action.move-column-to-monitor-right = [];
          "Mod+C".action.focus-workspace = "chats";
          "Mod+Shift+C".action.move-column-to-workspace = "chats";
          "Mod+Return".action.spawn = "ghostty";
          "Mod+R".action.spawn = ["${noctalia}/bin/noctalia" "msg" "panel-toggle" "launcher"];
          "Mod+Shift+W".action.spawn = ["${noctalia}/bin/noctalia" "msg" "wallpaper-random"];
          "Mod+P".action.spawn = ["${noctalia}/bin/noctalia" "msg" "panel-toggle" "control-center"];
          "Mod+Shift+P".action.spawn = ["${noctalia}/bin/noctalia" "msg" "settings-open"];
          "Mod+Escape".action.spawn = ["${noctalia}/bin/noctalia" "msg" "session" "lock"];
          "Mod+Ctrl+H".action.focus-monitor-left = [];
          "Mod+Ctrl+L".action.focus-monitor-right = [];
          "Mod+Shift+Left".action.move-column-to-monitor-left = [];
          "Mod+Shift+Right".action.move-column-to-monitor-right = [];
          "Mod+H".action.focus-column-left = [];
          "Mod+L".action.focus-column-right = [];
          "Mod+K".action.focus-window-or-workspace-up = [];
          "Mod+J".action.focus-window-or-workspace-down = [];
          "Mod+Shift+H".action.move-column-left = [];
          "Mod+Shift+L".action.move-column-right = [];
          "Mod+Shift+J".action.move-window-down-or-to-workspace-down = [];
          "Mod+Shift+K".action.move-window-up-or-to-workspace-up = []; # Fixed 'down' typo from your snippet
          "Mod+W".action.close-window = [];
          "Mod+Ctrl+W".action.quit.skip-confirmation = true;
          "Mod+F".action.maximize-column = [];
          "XF86AudioRaiseVolume".action.spawn = ["${pkgs.wireplumber}/bin/wpctl" "set-volume" "-l" "1.0" "@DEFAULT_AUDIO_SINK@" "5%+"];
          "XF86AudioLowerVolume".action.spawn = ["${pkgs.wireplumber}/bin/wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"];
          "XF86AudioMute".action.spawn = ["${pkgs.wireplumber}/bin/wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"];
          "XF86AudioMicMute".action.spawn = ["${pkgs.wireplumber}/bin/wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"];
          "XF86AudioPlay".action.spawn = ["${pkgs.playerctl}/bin/playerctl" "play-pause"];
          "XF86AudioStop".action.spawn = ["${pkgs.playerctl}/bin/playerctl" "stop"];
          "XF86AudioPrev".action.spawn = ["${pkgs.playerctl}/bin/playerctl" "previous"];
          "XF86AudioNext".action.spawn = ["${pkgs.playerctl}/bin/playerctl" "next"];
          "Print".action.screenshot = {};
          "Ctrl+Print".action.screenshot-screen = {
            write-to-disk = false;
          };
        };
      outputs = {
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
        "DP-1" = {
          mode = {
            width = 1920;
            height = 1080;
            refresh = 60.0;
          };
          position = {
            x = 3840;
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

    home.packages = with pkgs; [
      nautilus
      xwayland-satellite
    ];

    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
        obs-vaapi
        obs-gstreamer
        obs-vkcapture
        obs-move-transition
        obs-multi-rtmp
      ];
    };

    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gnome
        pkgs.xdg-desktop-portal-gtk
      ];
      config = {
        common.default = ["gtk"];
        niri.default = ["gnome" "gtk"];
      };
    };
  }
