{
  lib,
  pkgs,
  ...
}: {
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
}
