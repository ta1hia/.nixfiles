{ inputs, pkgs, ... }:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];

  programs.nixvim = {
    enable = true;

    nixpkgs = {
      config = {
        allowUnfree = true;
      };
    };

    defaultEditor = true;

    globals = {
      mapleader = ",";
    };

    diagnostic.settings = {
      virtual_text = true;
    };

    extraConfigVim = ''
      " use my term's colours
      set notermguicolors

      " use 4 spaces for tabs and indentation
      set tabstop=4
      set shiftwidth=4
      set expandtab

      " use smart indenting
      set autoindent
      set smartindent

      " needed for obsidian plugin
      set conceallevel=1

      " highlight for visual selection
      hi Visual ctermfg=NONE ctermbg=1

      " line number
      set number
      highlight LineNr ctermfg=240 guifg=#666666
    '';


    extraConfigLua = ''
      -- GIT AUTO SYNC
      -- auto sync for obs vault
      local function fugitive_commit_and_push()
        if vim.fn.finddir('.git', '.;') ~= "" and vim.bo.buftype == "" then
          local filename = vim.fn.expand('%:t')
          local message = "auto push notes in " .. filename
          local safe_message = vim.fn.shellescape(message)
          vim.cmd('Git add -A')
          pcall(vim.cmd, 'Git commit -m ' .. safe_message)
          vim.cmd('Git push')
        end
      end

      local function fugitive_pull_check()
        local target_path = vim.fn.resolve(vim.fn.expand('~/docs/notes'))
        local current_dir = vim.fn.resolve(vim.fn.getcwd()) 
        if current_dir == target_path and vim.fn.finddir('.git', '.;') ~= "" then
          vim.cmd.Git('pull --ff-only')
        end
      end
      
      local augroup = vim.api.nvim_create_augroup('GitAutoSync', { clear = true })
      local pattern = '*/docs/notes/**'
      
      vim.api.nvim_create_autocmd({ 'VimEnter' }, {  
        group = augroup,
        pattern = '*',
        callback = fugitive_pull_check,
        desc = 'auto git pull on neovim startup if in target dir'
      })
      
      vim.api.nvim_create_autocmd({ 'DirChanged' }, {
        group = augroup,
        pattern = '*', 
        callback = fugitive_pull_check,
        desc = 'auto git pull on entering the notes dir'
      })
      
      vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
        group = augroup,
        pattern = pattern,
        callback = fugitive_commit_and_push,
        desc = 'auto git commit & push on file save in notes dir'
      })

      -- GLOBAL DIAGNOSTIC FILTER
      -- filter out specific error messages that marksman incorrectly flags in obs
      local function filter_diagnostics(diagnostic)
        local ignore_list = { 
          "Link to non%-existent document", 
          "Ambiguous link"                  
        }

        for _, pattern in ipairs(ignore_list) do
          if string.match(diagnostic.message, pattern) then
            return false
          end
        end
        return true
      end

      -- overwrite the global handler that prints errors to the screen
      -- and filter out the unwanted ones (obs id/marksman errors)
      vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
        
        local client_id = ctx.client_id
        local client = vim.lsp.get_client_by_id(client_id)
        
        if client and client.name == 'marksman' and result and result.diagnostics then
          local filtered_diagnostics = {}
          for _, d in ipairs(result.diagnostics) do
            -- CHANGED HERE: Use 'filter_diagnostics' to match your existing function
            if filter_diagnostics(d) then
              table.insert(filtered_diagnostics, d)
            end
          end
          result.diagnostics = filtered_diagnostics
        end

        vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
      end
    '';

    extraLuaPackages = luaPkgs: [ luaPkgs.magick ];

    extraPackages = with pkgs; [
      imagemagick
      mermaid-cli
      nodejs_20

      # formatters, lang servers
      nixpkgs-fmt
      nodePackages.prettier
      nodePackages."@tailwindcss/language-server"
      gotools
      rustfmt
    ];

    files."after/ftplugin/markdown.lua" = {
      opts = {
        tabstop = 2;
        shiftwidth = 2;
        softtabstop = 2;
        expandtab = true;
      };
    };

    plugins.aerial = {
      enable = true;
      settings = {
        open_automatic = false; # Opens only via keymap
        layout = {
          # Basic configuration to use a standard sidebar window
          default_win_opts = {
            relativenumber = true;
          };
        };
        # Uses LSP data for accurate symbol parsing
        backends = [ "lsp" "treesitter" ];
      };
    };

    plugins.bufferline = {
      enable = true;
      settings = {
        options = {
          mode = "tabs";
          separator_style = "thin";
          show_buffer_close_icons = false;
          show_close_icon = false;
          color_icons = true;
          modified_icon = "●";

          offsets = [
            {
              filetype = "NvimTree";
              text_align = "left";
              separator = true;
            }
          ];

          diagnostics = "nvim_lsp";
          diagnostics_indicator = {
            __raw = ''
              function(count, level, diagnostics_dict, context)
                local s = ""
                for e, n in pairs(diagnostics_dict) do
                  local sym = e == "error" and " !"
                    or (e == "warning" and " ?" or "" )
                  if(sym ~= "") then
                    s = s .. " " .. n .. sym
                  end
                end
                return s
              end
            '';
          };

        };
      };
    };

    plugins.copilot-vim = {
      enable = true;
      settings = {
        filetypes = {
          "*" = false;
          javascript = true;
        };
      };
    };

    # auto-formatting based on the formatters i specify
    plugins.conform-nvim = {
      enable = true;
      settings = {
        format_on_save = {
          enabled = true;
          lsp_fallback = true;
        };
        formatters = {
          prettier_safe = {
            command = "prettier";
            args = [ "--stdin-filepath" "root_of_repo/dummy.md" "--parser" "markdown" ];
          };
        };
        formatters_by_ft = {
          nix = [ "nixpkgs_fmt" ];
          go = [ "gofmt" "goimports" ];
          javascript = [ "prettier" ];
          javascriptreact = [ "prettier" ];
          html = [ "prettier" ];
          css = [ "prettier" ];
          markdown = [ "prettier_safe" ];
          rust = [ "rustfmt" ];
        };
      };
    };
    plugins.fugitive.enable = true;

    # language servers
    plugins.lsp = {
      enable = true;
      servers = {
        bashls.enable = true; # bash
        gopls.enable = true; # go
        nixd.enable = true; # nix
        pyright.enable = true; # python
        ts_ls.enable = true; # js/typescript

        html.enable = true;
        cssls.enable = true;
        jsonls.enable = true;
        tailwindcss.enable = true;
        marksman.enable = true;

        rust_analyzer = {
          enable = true;
          installRustc = true;
          installCargo = true;
        };
      };
    };

    # completion plugin
    plugins.nvim-autopairs.enable = true;
    plugins.ts-autotag.enable = true;
    plugins.cmp-nvim-lsp.enable = true;
    plugins.cmp_luasnip.enable = true;
    plugins.friendly-snippets.enable = true;
    plugins.luasnip = {
      enable = true;
      fromVscode = [
        { }
      ];
    };
    plugins.cmp = {
      enable = true;
      autoEnableSources = true;
      settings = {
        sources = [
          { name = "nvim_lsp"; }
          { name = "path"; }
          { name = "buffer"; }
          { name = "luasnip"; }
        ];

        mapping = {
          "<Tab>" = "cmp.mapping.select_next_item()"; # select next item on tab
          "<S-Tab>" = "cmp.mapping.select_prev_item()"; # select previous item on shift+tab
          "<CR>" = "cmp.mapping.confirm({ select = true })"; # accept selected completion on enter
        };
      };

    };

    # diagrams dependency
    plugins.image = {
      enable = true;
    };

    # for diagrams in notes
    plugins.diagram = {
      enable = true;
      settings = {
        integrations = [
          {
            __raw = "require('diagram.integrations.markdown')";
          }
        ];
        renderer_options = {
          mermaid = {
            background = "transparent";
            theme = "neutral";
            scale = 2;
            cli_args = "--no-sandbox";
          };
        };
      };
    };

    plugins.gitsigns = {
      enable = true;
      settings = {
        signs = {
          add = { text = "│"; };
          change = { text = "│"; };
          delete = { text = "═"; };
          topdelete = { text = "‾"; };
          changedelete = { text = "~"; };
        };
        sign_priority = 6;
        # current_line_blame = true;
      };
    };

    plugins.nvim-tree = {
      enable = true;
      settings = {
        disable_netrw = true;
        hijack_netrw = true;
        view = {
          width = 22;
        };
        filters = {
          custom = [ "result" "*.swp" ];
        };

        # leave tree open on new tabs
        actions = {
          open_file = {
            quit_on_open = false;
          };
        };
        open_on_tab = true;
      };
    };


    # fuzzy-finder
    plugins.telescope = {
      enable = true;

      settings = {
        defaults = {
          file_ignore_patterns = [
            "^.git/"
          ];
        };

        pickers = {
          find_files = {
            hidden = true;
          };
        };
      };
    };

    plugins.treesitter = {
      enable = true;

      settings = {
        auto_install = true;
        highlight = {
          enable = true;
        };

        indent = {
          enable = true;
        };

        ensure_installed = [
          "go"
          "python"
          "javascript"
          "typescript"
          "html"
          "css"
          "json"
          "nix"
          "lua"
          "vim"
          "vimdoc"
        ];
      };
    };

    plugins.trouble = {
      enable = true;
      settings = {
        mode = "lsp_document";
        focus = true;
        use_diagnostic_signs = true;
        auto_open = false;
      };
    };

    plugins.web-devicons.enable = true;

    keymaps = [
      {
        mode = "n";
        key = "<C-h>";
        action = "<C-w>h";
        options = { desc = "Window Left"; };
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<C-w>l";
        options = { desc = "Window Right"; };
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<C-w>j";
        options = { desc = "Window Down"; };
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<C-w>k";
        options = { desc = "Window Up"; };
      }
      {
        mode = "n";
        key = "=";
        action = "<cmd>lua require('conform').format({ async = true, lsp_fallback = true })<cr>";
        options = { desc = "format (via conform) in normal mode"; };
      }
      {
        mode = "v";
        key = "=";
        action = "<cmd>lua require('conform').format({ async = true, lsp_fallback = true })<cr>";
        options = { desc = "format (via conform) in visual mode"; };
      }
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>Telescope find_files<cr>";
        options = { desc = "find files"; };
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd>Telescope live_grep<cr>";
        options = { desc = "live grep"; };
      }
      {
        mode = "n";
        key = "<leader>fk";
        action = "<cmd>Telescope keymaps<cr>";
        options = { desc = "find keymaps"; };
      }
      {
        mode = "n";
        key = "<leader>ee";
        action = "<cmd>lua vim.cmd('e')<cr>";
        options = { desc = "unfortunate obsidian.nvim backlink error suppression hack"; };
      }
      {
        mode = "n";
        key = "<leader>nn";
        action = "<cmd>NvimTreeFindFileToggle<cr>";
        options = { desc = "Toggle & Find Current File in Tree"; };
      }
      {
        mode = "n";
        key = "gr";
        action = "<cmd>Telescope lsp_references<cr>";
        options = { desc = "find references"; };
      }
      {
        mode = "n";
        key = "gd";
        action = "<cmd>Telescope lsp_definitions<cr>";
        options = { desc = "go to definition"; };
      }
      {
        mode = "n";
        key = "gD";
        action = "<cmd>lua vim.lsp.buf.declaration()<cr>";
        options = { desc = "go to declaration"; };
      }
      {
        mode = "n";
        key = "K";
        action = "<cmd>lua vim.lsp.buf.hover()<cr>";
        options = { desc = "show documentation"; };
      }
      {
        mode = "n";
        key = "]c";
        action = "<cmd>Gitsigns next_hunk<cr>";
        options = { desc = "Next Git Hunk"; };
      }
      {
        mode = "n";
        key = "[c";
        action = "<cmd>Gitsigns prev_hunk<cr>";
        options = { desc = "Previous Git Hunk"; };
      }
      {
        mode = "n";
        key = "<leader>gs";
        action = "<cmd>Gitsigns stage_hunk<cr>";
        options = { desc = "Stage Hunk"; };
      }
      {
        mode = "n";
        key = "<leader>gp";
        action = "<cmd>Gitsigns preview_hunk<cr>";
        options = { desc = "Preview Hunk"; };
      }
      {
        mode = "n";
        key = "<leader>xx";
        action = "<cmd>Trouble toggle diagnostics<cr>";
        options = { desc = "Toggle Project Diagnostics"; };
      }
      {
        mode = "n";
        key = "<leader>ca";
        action = "<cmd>AerialToggle<cr>";
        options = { desc = "Toggle Code Outline Sidebar"; };
      }
    ];
  };
}

