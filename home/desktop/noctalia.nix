{
  inputs,
  pkgs,
  ...
}: {
  programs.noctalia = {
    enable = true;
    package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
    settings = {
      shell = {
        font_family = "Lexend Deca";
        time_format = "{:%H:%M}";
        avatar_path = ../assets/avatar.jpg;
        corner_radius_scale = 1.1;
        popup_borders = true;
        popup_shadows = true;

        animation = {
          enabled = true;
          speed = 1.35;
        };

        shadow = {
          direction = "down";
          alpha = 0.3;
        };

        panel = {
          transparency_mode = "soft";
          borders = true;
          shadow = true;
          launcher_placement = "floating";
          control_center_placement = "floating";
          launcher_position = "center";
          control_center_position = "top_left";
          floating_offset = 16;
        };
      };

      wallpaper = {
        enabled = true;
        directory = ../assets/wallpapers;
        default.path = ../assets/wallpapers/wallpaper.jpg;
        transition = [
          "fade"
          "wipe"
          "disc"
          "stripes"
          "zoom"
          "honeycomb"
        ];
        transition_duration = 1200;

        automation = {
          enabled = true;
          interval_seconds = 10 * 60;
          order = "random";
          recursive = false;
        };
      };

      theme = {
        mode = "dark";
        source = "wallpaper";
        wallpaper_scheme = "m3-tonal-spot";
      };

      notification = {
        enable_daemon = true;
        show_actions = true;
        background_opacity = 0.9;
      };

      location.address = "Blumenau, SC";

      weather = {
        enabled = true;
        unit = "metric";
      };

      plugins = {
        enabled = ["noctalia/bitwarden"];
        auto_update = true;
      };

      # Mirrored desktop dashboards for every display. These are separate
      # layer-shell surfaces and do not alter the bar below.
      desktop_widgets = let
        outputs = ["DP-1" "DP-2" "DP-3"];
        widgetNames = [
          "greeting"
          "date"
          "media"
          "system"
          "weather"
          "files"
          "chrome"
          "ghostty"
          "steam"
        ];
      in {
        enabled = true;
        schema_version = 2;
        widget_order =
          builtins.concatMap (
            output: map (name: "${output}-${name}") widgetNames
          )
          outputs;

        grid = {
          visible = false;
          cell_size = 16;
          major_interval = 4;
        };

        widget = let
          baseWidgets = {
            date = {
              type = "clock";
              cx = 176.0;
              cy = 252.0;
              box_width = 320.0;
              box_height = 128.0;
              settings = {
                format = "{:%H:%M\n%A, %B %d}";
                center_text = false;
                color = "on_surface";
                shadow = true;
                background = true;
                background_color = "surface";
                background_opacity = 0.72;
                background_radius = 14;
                background_padding = 16;
              };
            };

            greeting = {
              type = "label";
              cx = 176.0;
              cy = 116.0;
              box_width = 320.0;
              box_height = 112.0;
              settings = {
                title = "Welcome home, shinobu.";
                description = "NixOS · Niri";
                color = "primary";
                shadow = true;
                background = true;
                background_color = "surface";
                background_opacity = 0.72;
                background_radius = 14;
                background_padding = 16;
              };
            };

            system = {
              type = "sysmon";
              cx = 1736.0;
              cy = 140.0;
              box_width = 336.0;
              box_height = 160.0;
              settings = {
                stat = "cpu_usage";
                stat2 = "ram_pct";
                display = "graph";
                color = "primary";
                color2 = "secondary";
                show_label = true;
                shadow = true;
                background = true;
                background_color = "surface";
                background_opacity = 0.72;
                background_radius = 20;
                background_padding = 10;
              };
            };

            media = {
              type = "media_player";
              cx = 1680.0;
              cy = 324.0;
              box_width = 448.0;
              box_height = 176.0;
              settings = {
                layout = "horizontal";
                color = "on_surface";
                shadow = true;
                hide_when_no_media = false;
                background = true;
                background_color = "surface";
                background_opacity = 0.72;
                background_radius = 20;
                background_padding = 16;
              };
            };

            weather = {
              type = "weather";
              cx = 176.0;
              cy = 396.0;
              box_width = 320.0;
              box_height = 128.0;
              settings = {
                color = "on_surface";
                shadow = true;
                show_forecast = false;
                background = true;
                background_color = "surface";
                background_opacity = 0.72;
                background_radius = 14;
                background_padding = 16;
              };
            };

            files = {
              type = "button";
              cx = 48.0;
              cy = 504.0;
              box_width = 56.0;
              box_height = 56.0;
              settings = {
                glyph = "folder";
                command = "nautilus --new-window";
                variant = "default";
                background = true;
              };
            };

            chrome = {
              type = "button";
              cx = 128.0;
              cy = 504.0;
              box_width = 56.0;
              box_height = 56.0;
              settings = {
                glyph = "brand-chrome";
                command = "google-chrome-stable";
                variant = "default";
                background = true;
              };
            };

            ghostty = {
              type = "button";
              cx = 208.0;
              cy = 504.0;
              box_width = 56.0;
              box_height = 56.0;
              settings = {
                glyph = "terminal-2";
                command = "ghostty";
                variant = "default";
                background = true;
              };
            };

            steam = {
              type = "button";
              cx = 288.0;
              cy = 504.0;
              box_width = 56.0;
              box_height = 56.0;
              settings = {
                glyph = "brand-steam";
                command = "steam";
                variant = "default";
                background = true;
              };
            };
          };
        in
          builtins.listToAttrs (
            builtins.concatMap (
              output:
                map (name: {
                  name = "${output}-${name}";
                  value = baseWidgets.${name} // {inherit output;};
                })
                widgetNames
            )
            outputs
          );
      };

      idle.behavior = {
        lock = {
          enabled = true;
          timeout = 60 * 15;
          action = "lock";
        };
        "screen-off" = {
          enabled = true;
          timeout = 60 * 20;
          action = "screen_off";
        };
        "lock-and-suspend" = {
          enabled = true;
          timeout = 60 * 25;
          action = "lock_and_suspend";
        };
      };

      widget.control-center = {
        glyph = "bat";
      };

      widget.cpu = {
        type = "sysmon";
        stat = "cpu_usage";
        glyph = "cpu";
        display = "text";
      };

      widget.ram = {
        type = "sysmon";
        stat = "ram_used";
        glyph = "server";
      };

      widget.weather = {
        show_condition = false;
        show_temperature = true;
      };

      widget.active_window = {
        display = "icon_and_text";
        min_length = 80;
        max_length = 360;
        title_scroll = "on_hover";
        show_empty_label = false;
      };

      widget."right-separator-1" = {
        type = "text";
        text = "│";
        color = "outline";
        interactive = false;
        scale = 0.8;
      };
      widget."right-separator-2" = {
        type = "text";
        text = "│";
        color = "outline";
        interactive = false;
        scale = 0.8;
      };
      widget."right-separator-3" = {
        type = "text";
        text = "│";
        color = "outline";
        interactive = false;
        scale = 0.8;
      };
      widget."right-separator-4" = {
        type = "text";
        text = "│";
        color = "outline";
        interactive = false;
        scale = 0.8;
      };
      widget."right-separator-5" = {
        type = "text";
        text = "│";
        color = "outline";
        interactive = false;
        scale = 0.8;
      };

      bar.main = {
        position = "top";
        thickness = 44;
        radius = 999;
        scale = 1.15;
        background_opacity = 0.0;
        border_width = 0;
        margin_ends = 8;
        margin_edge = 8;
        padding = 0;
        widget_spacing = 12;
        shadow = false;
        capsule = true;
        capsule_thickness = 0.88;
        capsule_fill = "surface";
        capsule_opacity = 0.78;
        capsule_radius = 999;
        capsule_padding = 8;
        capsule_border = "outline";

        capsule_group = [
          {
            id = "left";
            members = [
              "control-center"
              "workspaces"
              "media"
            ];
            fill = "surface";
            border = "outline";
            radius = 999;
            opacity = 0.78;
            padding = 8;
            widget_spacing = 12;
          }
          {
            id = "right";
            members = [
              "weather"
              "right-separator-1"
              "volume"
              "right-separator-2"
              "cpu"
              "right-separator-3"
              "ram"
              "right-separator-4"
              "clock"
              "right-separator-5"
              "notifications"
            ];
            fill = "surface";
            border = "outline";
            radius = 999;
            opacity = 0.78;
            padding = 8;
            widget_spacing = 12;
          }
        ];

        start = ["group:left"];
        center = ["active_window"];
        end = ["group:right"];
      };
    };
  };
}
