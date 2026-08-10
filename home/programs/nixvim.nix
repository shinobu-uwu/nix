{
  inputs,
  pkgs,
  ...
}: {
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    nixpkgs.source = inputs.nixpkgs;
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
      tombi
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
      tabstop = 2;
      shiftwidth = 2;
      softtabstop = 2;
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

    colorschemes.onedark = {
      enable = true;
      settings = {
        style = "darker";
      };
    };

    plugins = {
      web-devicons.enable = true;
      treesitter = {
        enable = true;
        settings = {
          highlight = {
            enable = true;
          };
          indent = {
            enable = true;
          };
        };
      };
      nvim-autopairs.enable = true;
      guess-indent.enable = true;
      todo-comments.enable = true;
      fidget.enable = true;
      indent-blankline.enable = true;
      nui.enable = true;
      ts-autotag.enable = true;
      sleuth.enable = true;
      crates.enable = true;
      inc-rename.enable = true;
      scrollview.enable = true;
      oil.enable = true;
      barbecue.enable = true;
      lastplace.enable = true;
      illuminate = {
        enable = true;
        settings = {
          under_cursor = false;
          filetypes_denylist = ["NvimTree"];
        };
      };

      codesnap = {
        enable = true;
        settings = {
          snapshot_config = {
            watermark.content = "";
            code_config = {
              breadcrumbs.enable = false;
            };
          };
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
            {__raw = "require('actions-preview.highlight').diff_so_fancy()";}

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
          "<leader>b" = {
            action = "buffers";
            options.desc = "[b] Find existing buffers";
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
      };

      fff = {
        enable = true;
        settings = {
          lazy_sync = true;
          layout = {
            height = 0.9;
            width = 0.8;
            prompt_position = "top";
            preview_position = "right";
            preview_size = 0.6;
            border = "rounded";
          };
        };
        luaConfig.content = ''
          local fff = require('fff')

          vim.keymap.set('n', '<leader>?', function() fff.find_files({ resume = true }) end, { desc = '[?] Resume file search' })
          vim.keymap.set('n', '<leader>ss', fff.find_files, { desc = '[S]earch [S]elect files' })
          vim.keymap.set('n', '<leader>gf', fff.find_files, { desc = 'Search [G]it [F]iles' })
          vim.keymap.set('n', '<leader>ff', fff.find_files, { desc = '[F]ind [F]iles' })
          vim.keymap.set('n', '<leader>sw', fff.live_grep_under_cursor, { desc = '[S]earch current [W]ord' })
          vim.keymap.set('x', '<leader>sw', fff.live_grep_under_cursor, { desc = '[S]earch selection' })
          vim.keymap.set('n', '<leader>ps', fff.live_grep, { desc = 'Project search' })
          vim.keymap.set('n', '<leader>sr', function() fff.find_files({ resume = true }) end, { desc = '[S]earch [R]esume files' })
          vim.keymap.set('n', '<leader>sR', function() fff.live_grep({ resume = true }) end, { desc = '[S]earch resume grep' })
          vim.keymap.set('n', '<leader>/', function()
            local file = vim.api.nvim_buf_get_name(0)
            if #file == 0 then
              return
            end
            fff.live_grep({
              cwd = vim.fn.fnamemodify(file, ':h'),
              query = vim.fn.fnamemodify(file, ':t') .. ' ',
              title = 'Grep current file',
            })
          end, { desc = '[/] Search in current buffer' })

          vim.keymap.set('n', '<leader>s/', fff.live_grep, { desc = '[S]earch [/] project' })

          vim.keymap.set('n', '<leader>sn', function()
            fff.find_files_in_dir(vim.fn.stdpath('config'))
          end, { desc = '[S]earch [N]eovim files' })

          vim.keymap.set('n', '<leader>sh', function()
            vim.ui.input({ prompt = 'Help: ' }, function(query)
              if query and #query > 0 then
                vim.cmd.help(query)
              end
            end)
          end, { desc = '[S]earch [H]elp' })

          vim.keymap.set('n', '<leader>sd', function()
            vim.diagnostic.setqflist()
            vim.cmd.copen()
          end, { desc = '[S]earch [D]iagnostics' })
        '';
      };

      lint = {
        enable = true;
        lintersByFt = {
          go = ["golangcilint"];
          lua = ["luacheck"];
          markdown = ["vale"];
          c = ["clangtidy"];
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

      colorizer = {
        enable = true;
        settings = {
          display = {
            mode = "virtualtext";
          };
        };
      };

      conform-nvim = {
        enable = true;
        autoInstall.enable = true;
        autoInstall.overrides.markdownfmt = null;
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
            lua = ["stylua"];
            javascript = ["biome"];
            typescript = ["biome"];
            css = ["biome"];
            typescriptreact = ["biome"];
            svelte = ["biome"];
            rust = ["rustfmt"];
            go = [
              "goimports"
              "golines"
              "gofmt"
              "gofumpt"
            ];
            c = ["clang-format"];
            cpp = ["clang-format"];
            json = ["fixjson"];
            nix = ["alejandra"];
            markdown = ["markdownfmt"];
            toml = ["tombi"];
            terraform = ["terraform_fmt"];
            python = [
              "isort"
              "black"
            ];
          };
        };
      };

      lsp = {
        enable = true;
        inlayHints = false;
        servers = {
          nil_ls.enable = true;
          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
            settings = {
              check = {
                command = "clippy";
              };
              procMacro = {
                enable = true;
              };
              cargo = {
                allTargets = false;
              };
            };
          };
          gopls.enable = true;
          ts_ls.enable = true;
          lua_ls.enable = true;
          svelte.enable = true;
          clangd.enable = true;
          tombi.enable = true;
        };
      };
      luasnip = {
        enable = true;
        fromVscode = [{}];
      };

      mini = {
        enable = true;
        modules = {
          ai = {
            n_lines = 500;
          };
          surround = {};
          statusline.use_icons = true;
        };
        luaConfig.content = ''
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
            use_nvim_cmp_as_default = true;
            nerd_font_variant = "mono";
          };
          completion = {
            menu = {
              draw = {
                columns = [
                  {__raw = "{ 'label', 'label_description', 'kind_icon', gap = 1 }";}
                  {__raw = "{ 'kind' }";}
                ];
              };
            };
            documentation = {
              auto_show = true;
              auto_show_delay_ms = 200;
            };
          };
          sources = {
            default = [
              "lsp"
              "path"
              "snippets"
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
