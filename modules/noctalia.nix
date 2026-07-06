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
      };

      wallpaper = {
        directory = "~/Pictures";
        default.path = "/home/shinobu/Pictures/wallpaper.jpg";
      };

      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Dracula";
      };

      notification = {
        enable_daemon = true;
        show_actions = true;
        background_opacity = 0.97;
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

      bar.main = {
        position = "top";
        thickness = 34;
        background_opacity = 1.0;
        radius = 12;
        margin_h = 8;
        margin_v = 4;
        padding = 10;
        widget_spacing = 6;
        reserve_space = true;
        start = [
          "launcher"
          "workspaces"
          "media"
        ];
        center = ["clock"];
        end = [
          "tray"
          "notifications"
          "clipboard"
          "network"
          "bluetooth"
          "volume"
          "brightness"
          "battery"
          "control-center"
          "session"
        ];
      };
    };
  };
}
