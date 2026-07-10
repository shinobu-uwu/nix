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
