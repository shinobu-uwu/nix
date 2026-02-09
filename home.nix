let
  # Generates Mod+1..9 and Mod+Shift+1..9
  workspaceBinds = builtins.listToAttrs (
    builtins.concatMap (
      i:
      let
        key = toString i;
      in
      [
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
}:
{
  home.username = "shinobu";
  home.homeDirectory = "/home/shinobu";
  home.stateVersion = "25.11";
  imports = [ inputs.nixvim.homeModules.nixvim ];

  services.swayidle =
    let
      lock = "${pkgs.swaylock}/bin/swaylock --daemonize";
      display = status: "${pkgs.niri}/bin/niri msg action power-${status}-monitors";
    in
    {
      enable = true;
      timeouts = [
        {
          timeout = 60 * 4;
          command = lock;
        }
        {
          timeout = 60 * 5;
          command = display "off";
          resumeCommand = display "on";
        }
        {
          timeout = 60 * 15;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
      events = [
        {
          event = "before-sleep";
          # adding duplicated entries for the same event may not work
          command = (display "off") + "; " + lock;
        }
        {
          event = "after-resume";
          command = display "on";
        }
        {
          event = "lock";
          command = (display "off") + "; " + lock;
        }
        {
          event = "unlock";
          command = display "on";
        }
      ];
    };

  services.mako = {
    enable = true;
    settings = {
      background-color = "#282a36";
      text-color = "#f8f8f2";
      border-color = "#44475a";
      progress-color = "#ff5555";
      default-timeout = 5000;
      ignore-timeout = false;
      max-visible = 5;
      actions = true;
    };
  };

  programs.fuzzel = {
    enable = true;
    settings = {
      colors = {
        background = "#282a36dd";
        text = "#f8f8f2ff";
        match = "#8be9fdff";
        selection-match = "#8be9fdff";
        selection = "#44475add";
        selection-text = "#f8f8f2ff";
        border = "#bd93f9ff";
      };
    };
  };

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
        modules-left = [
          "niri/workspaces"
          "pulseaudio"
          "mpris"
        ];
        modules-center = [ "niri/window" ];
        modules-right = [
          "cpu"
          "memory"
          "clock"
        ];
        "niri/workspaces" = {
          format = "{icon}";
          format-icons = {
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            "chats" = "";
            "default" = "";
          };
        };
        "niri/window" = {
          separate-outputs = true;
          max-length = 40;
        };
        "pulseaudio" = {
          format = ''<span size="large" rise="-1pt">{icon}</span>  {volume}%'';
          format-muted = "󰝟";
          format-icons = {
            default = [
              "󰕿"
              "󰖀"
              "󰕾"
            ];
          };
        };
        "cpu" = {
          interval = 1;
          format = ''<span size="large" rise="-1pt"></span>  {usage}%'';
        };
        "mpris" = {
          format = "{player_icon} {dynamic}";
          format-paused = "{status_icon} <i>{dynamic}</i>";
          dynamic-order = [
            "artist"
            "title"
          ];
          dynamic-len = 15;
          player-icons = {
            default = "▶";
            chromium = "";
            firefox = "󰈹";
            mpv = "";
          };
          status-icons = {
            paused = "";
          };
        };
        "memory" = {
          interval = 5;
          format = "  {used:0.1f}G";
        };
        "battery" = {
          format = ''<span size="large" rise="-1pt">{icon}</span> {capacity}%'';
          format-icons = [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
          format-charging = ''<span size="large" rise="-1pt">󰂅</span>  {capacity}%'';
        };
        "backlight" = {
          format = ''<span size="large" rise="-1pt">{icon}</span>  {percent}%'';
          format-icons = [
            "󰃚"
            "󰃛"
            "󰃜"
            "󰃝"
            "󰃞"
            "󰃟"
            "󰃠"
          ];
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
        padding: 0 12px;
        color: @foreground;
        background-image: linear-gradient(
          to bottom, 
          transparent 20%, 
          @grey 20%, 
          @grey 80%, 
          transparent 80%
        );
        background-size: 1px 100%;
        background-repeat: no-repeat;
        background-position: right center;
        border-radius: 0;
      }

      #workspaces button:last-child {
        background-image: none;
        border-radius: 0 20px 20px 0;
      }

      #workspaces button:first-child {
        border-radius: 20px 0 0 20px;
      }

      #workspaces button:only-child {
        border-radius: 20px;
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
      #mpris, 
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
      #mpris { border-left: 10px solid @pink; border-right: 10px solid @pink; background-color: @pink; }
    '';

  };

  programs.niri.settings = {
    prefer-no-csd = true;
    spawn-at-startup = [
      { argv = [ "${pkgs.vesktop}/bin/vesktop" ]; }
      { argv = [ "${pkgs.zapzap}/bin/zapzap" ]; }
      { argv = [ "${pkgs.waybar}/bin/waybar" ]; }
      {
        argv = [
          ''
            spawn-at-startup "dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
          ''
        ];
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
    gestures = {
      hot-corners.enable = false;
    };
    workspaces = {
      "chats" = {
        open-on-output = "DP-2";
      };
    };
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
        matches = [
          { app-id = "zapzap"; }
          { app-id = "vesktop"; }
        ];
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
      "Mod+Shift+K".action.move-window-up-or-to-workspace-up = [ ]; # Fixed 'down' typo from your snippet
      "Mod+W".action.close-window = [ ];
      "Mod+Ctrl+W".action.quit.skip-confirmation = true;
      "Mod+F".action.maximize-column = [ ];
      "Ctrl+Print".action.screenshot-screen = {
        write-to-disk = false;
      };
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
        args = [
          "-l"
          "-c"
          "tmux"
        ];
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
      alias ls='eza --icons'
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
  programs = {
    nushell = {
      enable = true;
      extraConfig = ''
        # direnv
        use std/config *

        # Initialize the PWD hook as an empty list if it doesn't exist
        $env.config.hooks.env_change.PWD = $env.config.hooks.env_change.PWD? | default []

        $env.config.hooks.env_change.PWD ++= [{||
          if (which direnv | is-empty) {
            # If direnv isn't installed, do nothing
            return
          }

          direnv export json | from json | default {} | load-env
          # If direnv changes the PATH, it will become a string and we need to re-convert it to a list
          $env.PATH = do (env-conversions).path.from_string $env.PATH
        }]

        # Completions
        # mainly pieced together from https://www.nushell.sh/cookbook/external_completers.html

        # carapace completions https://www.nushell.sh/cookbook/external_completers.html#carapace-completer
        # + fix https://www.nushell.sh/cookbook/external_completers.html#err-unknown-shorthand-flag-using-carapace
        # enable the package and integration bellow
              let carapace_completer = {|spans: list<string>|
                carapace $spans.0 nushell ...$spans
                  | from json
                  | if ($in | default [] | where value == $"($spans | last)ERR" | is-empty) { $in } else { null }
              }
        # some completions are only available through a bridge
        # eg. tailscale
        # https://carapace-sh.github.io/carapace-bin/setup.html#nushell
              $env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'

        # fish completions https://www.nushell.sh/cookbook/external_completers.html#fish-completer
                let fish_completer = {|spans|
                  ${lib.getExe pkgs.fish} --command $'complete "--do-complete=($spans | str join " ")"'
                  | $"value(char tab)description(char newline)" + $in
                    | from tsv --flexible --no-infer
                }

        # zoxide completions https://www.nushell.sh/cookbook/external_completers.html#zoxide-completer
              let zoxide_completer = {|spans|
                $spans | skip 1 | zoxide query -l ...$in | lines | where {|x| $x != $env.PWD}
              }

        # multiple completions
        # the default will be carapace, but you can also switch to fish
        # https://www.nushell.sh/cookbook/external_completers.html#alias-completions
              let multiple_completers = {|spans|
        ## alias fixer start https://www.nushell.sh/cookbook/external_completers.html#alias-completions
                let expanded_alias = scope aliases
                  | where name == $spans.0
                  | get -o 0.expansion

                  let spans = if $expanded_alias != null {
                    $spans
                      | skip 1
                      | prepend ($expanded_alias | split row ' ' | take 1)
                  } else {
                    $spans
                  }
        ## alias fixer end

                match $spans.0 {
                  __zoxide_z | __zoxide_zi => $zoxide_completer
                    _ => $carapace_completer
                } | do $in $spans
              }
              $env.config = {
        edit_mode: 'vi',
                   show_banner: false,
                   completions: {
        case_sensitive: false # case-sensitive completions
                          quick: true           # set to false to prevent auto-selecting completions
                          partial: true         # set to false to prevent partial filling of the prompt
                          algorithm: "fuzzy"    # prefix or fuzzy
                          external: {
        # set to false to prevent nushell looking into $env.PATH to find more suggestions
        enable: true 
        # set to lower can improve completion performance at the cost of omitting some options
                  max_results: 100 
                  completer: $multiple_completers
                          }
                   }
              } 
              $env.PATH = ($env.PATH | 
                  split row (char esep) |
                  prepend /home/myuser/.apps |
                  append /usr/bin/env
                  )
      '';
      shellAliases = {
        vi = "hx";
        vim = "hx";
        nano = "hx";
      };
    };
    carapace.enable = true;
    carapace.enableNushellIntegration = true;

    starship = {
      enable = true;
      settings = {
        aws.style = "bold #ffb86c";
        cmd_duration.style = "bold #f1fa8c";
        directory = {
          style = "bold #50fa7b";
          truncation_length = 0;
          truncate_to_repo = false;
        };
        hostname.style = "bold #ff5555";
        git_branch.style = "bold #ff79c6";
        git_status.style = "bold #ff5555";
        username = {
          format = "[$user]($style) on ";
          style_user = "bold #bd93f9";
        };
        character = {
          success_symbol = "[ ](bold #f8f8f2)";
          error_symbol = "[ ](bold #ff5555)";
        };
      };
    };

    zoxide = {
      enable = true;
      enableNushellIntegration = true;
    };

    direnv = {
      enable = true;
      enableNushellIntegration = true;
      nix-direnv = {
        enable = true;
      };
    };
  };

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    globals.mapleader = " ";

    extraPackages = with pkgs; [
      markdownlint-cli
      golangci-lint
      luajitPackages.luacheck
      clang-tools
      typescript-language-server
      gopls
      luajitPackages.lua-lsp
      svelte-language-server
      luarocks
    ];

    opts = {
      number = true;
      mouse = "a";
      showmode = false;
      clipboard = "unnamedplus";
      breakindent = true;
      undofile = true;
      ignorecase = true;
      smartcase = true;
      signcolumn = "yes";
      updatetime = 250;
      timeoutlen = 300;
      splitright = true;
      splitbelow = true;
      listchars = {
        tab = "» ";
        trail = "·";
        nbsp = "␣";
      };
      inccommand = "split";
      cursorline = true;
      scrolloff = 10;
      confirm = true;
    };
    diagnostic.settings = {
      update_in_insert = false;
      severity_sort = true;
      float = {
        border = "rounded";
        source = "if_many";
      };
      virtual_text = true;
      virtual_lines = false;
      jump = {
        float = true;
      };
    };

    keymaps = [
      {
        mode = [
          "n"
          "v"
        ];
        key = "<M-Enter>";
        action.__raw = "require('actions-preview').code_actions";
        options.desc = "Code Actions Preview";
      }
      {
        mode = "n";
        key = "<M-2>";
        action.__raw = "require('oil').open";
        options.desc = "Open Oil File Browser";
      }
      {
        mode = "n";
        key = "gr";
        action.__raw = ''function() return ":IncRename " .. vim.fn.expand("<cword>") end'';
        options = {
          expr = true;
          desc = "Incremental Rename";
        };
      }
      {
        mode = "n";
        key = "<Esc>";
        action = "<cmd>nohlsearch<CR>";
      }

      {
        mode = "n";
        key = "<leader>q";
        action.__raw = "vim.diagnostic.setloclist";
        options.desc = "Open diagnostic [Q]uickfix list";
      }
      {
        mode = "n";
        key = "T";
        action.__raw = "function() vim.diagnostic.open_float(nil, { focus = false }) end";
        options = {
          silent = true;
          noremap = true;
        };
      }
      {
        mode = "n";
        key = "ge";
        action.__raw = "vim.diagnostic.goto_next";
        options = {
          desc = "Go to next diagnostic";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "gE";
        action.__raw = "vim.diagnostic.goto_prev";
        options = {
          desc = "Go to previous diagnostic";
          silent = true;
        };
      }
      {
        mode = "t";
        key = "<Esc><Esc>";
        action = "<C-\\><C-n>";
        options.desc = "Exit terminal mode";
      }
      {
        mode = "n";
        key = "<C-h>";
        action = "<C-w><C-h>";
        options.desc = "Move focus to the left window";
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<C-w><C-l>";
        options.desc = "Move focus to the right window";
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<C-w><C-j>";
        options.desc = "Move focus to the lower window";
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<C-w><C-k>";
        options.desc = "Move focus to the upper window";
      }
      {
        mode = "n";
        key = "<leader>ww";
        action = ":winc w<cr>";
        options.silent = true;
      }

      # Visual Mode Line Moving
      {
        mode = "v";
        key = "J";
        action = ":m '>+1<CR>gv=gv";
        options.silent = true;
      }
      {
        mode = "v";
        key = "K";
        action = ":m '<-2<CR>gv=gv";
        options.silent = true;
      }

      # Keep search results centered
      {
        mode = "n";
        key = "n";
        action = "nzzzv";
      }
      {
        mode = "n";
        key = "N";
        action = "Nzzzv";
      }
    ];

    autoGroups = {
      kickstart-highlight-yank = {
        clear = true;
      };
      lint.clear = true;
    };

    autoCmd = [
      {
        event = "TextYankPost";
        group = "kickstart-highlight-yank";
        desc = "Highlight when yanking (copying) text";
        callback.__raw = "function() vim.hl.on_yank() end";
      }
    ];

    colorschemes.onedark = {
      enable = true;
      settings = {
        style = "darker";
      };
    };

    plugins = {
      web-devicons.enable = true;
      treesitter.enable = true;
      nvim-autopairs.enable = true;
      guess-indent.enable = true;
      todo-comments.enable = true;
      fidget.enable = true;
      plenary.enable = true;
      indent-blankline.enable = true;
      nui.enable = true;
      ts-autotag.enable = true;
      sleuth.enable = true;
      crates.enable = true;
      inc-rename.enable = true;
      hlargs.enable = true;
      nvim-scrollbar.enable = true;
      oil.enable = true;
      barbecue.enable = true;
      lastplace.enable = true;
      illuminate = {
        enable = true;
        under_cursor = false;
        filetypes_denylist = [ "NvimTree" ];
      };

      codesnap = {
        enable = true;
        settings = {
          has_breadcrumbs = false;
          has_line_number = true;
          watermark = "";
        };
      };

      markdown-preview = {
        enable = true;
      };

      actions-preview = {
        enable = true;
        settings = {
          highlight_command = [
            {
              __raw = "require('actions-preview.highlight').delta 'delta --side-by-side'";
            }
            { __raw = "require('actions-preview.highlight').diff_so_fancy()"; }

            {
              __raw = "require('actions-preview.highlight').diff_highlight()";
            }
          ];
          telescope = {
            layout_config = {
              height = 0.9;
              preview_cutoff = 20;
              preview_height = {
                __raw = ''
                  function(_, _, max_lines)
                    return max_lines - 15
                  end
                '';
              };
              prompt_position = "top";
              width = 0.8;
            };
            layout_strategy = "vertical";
            sorting_strategy = "ascending";
          };
        };

      };

      telescope = {
        enable = true;
        extensions = {
          fzf-native.enable = true;
          ui-select = {
            enable = true;
            settings = {
              __raw = "require('telescope.themes').get_dropdown()";
            };
          };
        };
        keymaps = {
          "<leader>?" = {
            action = "oldfiles";
            options.desc = "[?] Find recently opened files";
          };
          "<leader>b" = {
            action = "buffers";
            options.desc = "[b] Find existing buffers";
          };
          "<leader>ss" = {
            action = "builtin";
            options.desc = "[S]earch [S]elect Telescope";
          };
          "<leader>gf" = {
            action = "git_files";
            options.desc = "Search [G]it [F]iles";
          };
          "<leader>ff" = {
            action = "find_files";
            options.desc = "[F]ind [F]iles";
          };
          "<leader>sh" = {
            action = "help_tags";
            options.desc = "[S]earch [H]elp";
          };
          "<leader>sw" = {
            action = "grep_string";
            options.desc = "[S]earch current [W]ord";
          };
          "<leader>ps" = {
            action = "live_grep";
            options.desc = "Project search";
          };
          "<leader>sd" = {
            action = "diagnostics";
            options.desc = "[S]earch [D]iagnostics";
          };
          "<leader>sr" = {
            action = "resume";
            options.desc = "[S]earch [R]esume";
          };
          "gd" = {
            action = "lsp_definitions";
            options.desc = "[G]o to [D]efinition";
          };
          "vu" = {
            action = "lsp_references";
            options.desc = "[V]iew [U]sages";
          };
        };
        extraConfigLua = ''
          local builtin = require('telescope.builtin')

          -- Fuzzily search in current buffer with specific theme
          vim.keymap.set('n', '<leader>/', function()
            builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
              winblend = 10,
              previewer = false,
            })
          end, { desc = '[/] Fuzzily search in current buffer' })

          -- Live Grep in Open Files
          vim.keymap.set('n', '<leader>s/', function()
            builtin.live_grep {
              grep_open_files = true,
              prompt_title = 'Live Grep in Open Files',
            }
          end, { desc = '[S]earch [/] in Open Files' })

          -- Search Neovim files (adapted for NixOS/Nixvim config path)
          vim.keymap.set('n', '<leader>sn', function() 
            builtin.find_files { cwd = vim.fn.stdpath 'config' } 
          end, { desc = '[S]earch [N]eovim files' })
        '';

        autoCmd = [
          {
            event = "LspAttach";
            callback.__raw = ''
              function(event)
                local opts = { buffer = event.buf }
                local builtin = require('telescope.builtin')

                vim.keymap.set('n', 'gri', builtin.lsp_implementations, { buffer = event.buf, desc = '[G]oto [I]mplementation' })
                vim.keymap.set('n', 'gO', builtin.lsp_document_symbols, { buffer = event.buf, desc = 'Open Document Symbols' })
                vim.keymap.set('n', 'gW', builtin.lsp_dynamic_workspace_symbols, { buffer = event.buf, desc = 'Open Workspace Symbols' })
                vim.keymap.set('n', 'grt', builtin.lsp_type_definitions, { buffer = event.buf, desc = '[G]oto [T]ype Definition' })
              end
            '';
          }
        ];
      };

      lint = {
        enable = true;
        lintersByFt = {
          markdown = [ "markdownlint" ];
          go = [ "golancilint" ];
          lua = [ "luacheck" ];
          json = [ "jsonlint" ];
          c = [ "clangtidy" ];
        };

        autoCmd = {
          event = [
            "BufEnter"
            "BufWritePost"
            "InsertLeave"
          ];
          group = "lint";
          callback.__raw = ''
            function()
              -- Only run the linter in buffers that you can modify
              if vim.bo.modifiable then
                require('lint').try_lint()
              end
            end
          '';
        };
      };

      gitsigns = {
        enable = true;
        settings = {
          signs = {
            add = {
              text = "+";
            };
            change = {
              text = "~";
            };
            delete = {
              text = "_";
            };
            topdelete = {
              text = "‾";
            };
            changedelete = {
              text = "~";
            };
          };
        };
      };

      which-key = {
        enable = true;
        settings = {
          delay = 200;
        };
      };

      conform-nvim = {
        enable = true;
        settings = {
          notify_on_error = false;

          format_on_save = ''
            function(bufnr)
              return {
                timeout_ms = 500,
                lsp_format = "fallback",
              }
            end
          '';

          formatters_by_ft = {
            lua = [ "stylua" ];
            javascript = [ "biome" ];
            typescript = [ "biome" ];
            css = [ "biome" ];
            typescriptreact = [ "biome" ];
            svelte = [ "biome" ];
            rust = [ "rustfmt" ];
            go = [
              "goimports"
              "gofmt"
            ];
            c = [ "clang-format" ];
            cpp = [ "clang-format" ];
            json = [ "fixjson" ];
            nix = [ "nixfmt" ];
          };
        };
      };
      lsp = {
        enable = true;
        servers.nil_ls.enable = true;
        servers.rust_analyzer = {
          enable = true;
          installCargo = true;
          installRustc = true;
          settings = {
            checkOnSave = true;
            check = {
              command = "clippy";
            };
            procMacro = {
              enable = true;
            };
          };
        };
        server.gopls.enable = true;
        server.ts_ls.enable = true;
        server.lua_ls.enable = true;
        server.svelte.enable = true;
        server.clangd.enable = true;
      };
      luasnip = {
        enable = true;
        fromVscode = [ { } ];
      };

      mini = {
        enable = true;
        modules = {
          ai = {
            n_lines = 500;
          };
          surround = { };
          statusline.use_icons = true;
        };
        extraConfigLua = ''
          require('mini.statusline').section_location = function() 
            return '%2l:%-2v' 
          end
        '';
      };

      blink-cmp = {
        enable = true;
        settings = {
          keymap = {
            preset = "enter";
          };
          appearance = {
            nerd_font_variant = "mono";
          };
          completion = {
            documentation = {
              auto_show = false;
              auto_show_delay_ms = 500;
            };
          };
          sources = {
            default = [
              "lsp"
              "path"
              "snippets"
              "buffer"
            ];
          };
          snippets = {
            preset = "luasnip";
          };
          fuzzy = {
            implementation = "lua";
          };
          signature = {
            enabled = true;
            window = {
              border = "rounded";
              scrollbar = true;
            };
          };
        };
      };
    };

  };
}
