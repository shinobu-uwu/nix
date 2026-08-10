{pkgs, ...}: {
  programs.alacritty = {
    enable = true;
    settings = {
      general.import = [pkgs.alacritty-theme.dracula];
      font = {
        size = 14.0;
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
      };
      terminal.shell = {
        program = "${pkgs.zsh}/bin/zsh";
        args = [
          "-l"
          "-c"
          "tmux"
        ];
      };
    };
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
          set -g @dracula-narrow-plugins "uptime network weather"
          set -g @dracula-show-powerline true
          set -g @dracula-refresh-rate 10
          set -g @dracula-fixed-location "Blumenau"
        '';
      }
    ];
    extraConfig = ''
      set-option -g status-position top
      set -g renumber-windows on
    '';
  };
  programs.ghostty = {
    enable = true;
    systemd.enable = true;
    settings = {
      theme = "Dracula";
      font-size = 14;
      font-feature = "-calt, -liga, -dlig";
      font-family = "JetBrainsMono Nerd Font";
      command = "tmux new-session -A -s ghostty";
      confirm-close-surface = false;
      window-padding-x = 0;
      window-padding-y = 0;
    };
  };
}
