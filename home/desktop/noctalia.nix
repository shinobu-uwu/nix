{
  inputs,
  pkgs,
  ...
}: {
  programs.noctalia = {
    enable = true;
    package = pkgs.callPackage (inputs.noctalia + "/nix/package.nix") {};
    settings = {
      shell = {
        font_family = "Lexend Deca";
        time_format = "{:%H:%M}";
        avatar_path = ../assets/avatar.jpg;
      };

      wallpaper.default.path = ../assets/wallpaper.jpg;

      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Dracula";
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

      # Mirrored desktop dashboards for every display. These are separate
      # layer-shell surfaces and do not alter the bar below.
      desktop_widgets = let
        outputs = ["DP-1" "DP-2" "DP-3"];
        widgetNames = [
          "date"
          "greeting"
          "system"
          "media"
          "terminal"
          "files"
          "browser"
          "discord"
          "weather"
          "volume"
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
              cy = 104.0;
              box_width = 296.0;
              box_height = 96.0;
              settings = {
                format = "{:%A\n%B %d, %Y}";
                center_text = false;
                color = "on_surface";
                shadow = true;
                background = true;
                background_color = "surface";
                background_opacity = 0.72;
                background_radius = 16;
                background_padding = 16;
              };
            };

            greeting = {
              type = "label";
              cx = 176.0;
              cy = 214.0;
              box_width = 296.0;
              box_height = 96.0;
              settings = {
                title = "Good evening, shinobu.";
                description = "Welcome home";
                color = "primary";
                shadow = true;
                background = true;
                background_color = "surface";
                background_opacity = 0.72;
                background_radius = 16;
                background_padding = 16;
              };
            };

            system = {
              type = "sysmon";
              cx = 176.0;
              cy = 342.0;
              box_width = 296.0;
              box_height = 128.0;
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
                background_radius = 16;
                background_padding = 16;
              };
            };

            media = {
              type = "media_player";
              cx = 176.0;
              cy = 500.0;
              box_width = 296.0;
              box_height = 156.0;
              settings = {
                layout = "horizontal";
                color = "on_surface";
                shadow = true;
                hide_when_no_media = false;
                background = true;
                background_color = "surface";
                background_opacity = 0.72;
                background_radius = 16;
                background_padding = 16;
              };
            };

            terminal = {
              type = "button";
              cx = 80.0;
              cy = 630.0;
              box_width = 56.0;
              box_height = 56.0;
              settings = {
                glyph = "terminal-2";
                command = "ghostty";
                variant = "default";
                background = true;
              };
            };

            files = {
              type = "button";
              cx = 144.0;
              cy = 630.0;
              box_width = 56.0;
              box_height = 56.0;
              settings = {
                glyph = "folder";
                command = "nautilus --new-window";
                variant = "default";
                background = true;
              };
            };

            browser = {
              type = "button";
              cx = 208.0;
              cy = 630.0;
              box_width = 56.0;
              box_height = 56.0;
              settings = {
                glyph = "brand-firefox";
                command = "firefox";
                variant = "default";
                background = true;
              };
            };

            discord = {
              type = "button";
              cx = 272.0;
              cy = 630.0;
              box_width = 56.0;
              box_height = 56.0;
              settings = {
                glyph = "brand-discord";
                command = "vesktop";
                variant = "default";
                background = true;
              };
            };

            weather = {
              type = "weather";
              cx = 1744.0;
              cy = 192.0;
              box_width = 296.0;
              box_height = 208.0;
              settings = {
                color = "on_surface";
                shadow = true;
                show_forecast = true;
                forecast_days = 5;
                background = true;
                background_color = "surface";
                background_opacity = 0.72;
                background_radius = 16;
                background_padding = 16;
              };
            };

            volume = {
              type = "volume";
              cx = 1744.0;
              cy = 390.0;
              box_width = 296.0;
              box_height = 152.0;
              settings = {
                device = "output";
                fill_color = "primary";
                track_color = "on_surface_variant";
                show_device = true;
                scroll_step = 5;
                shadow = true;
                background = true;
                background_color = "surface";
                background_opacity = 0.72;
                background_radius = 16;
                background_padding = 16;
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

      bar.main = {
        position = "top";
        thickness = 40;
        radius = 8;
        scale = 1.2;
        background_opacity = 1;
        margin_ends = 4;
        margin_edge = 4;
        padding = 8;
        widget_spacing = 16;

        start = [
          "control-center"
          "workspaces"
          "media"
        ];
        center = [];
        end = [
          "volume"
          "cpu"
          "ram"
          "clock"
          "notifications"
        ];
      };
    };
  };
}
