{ inputs, pkgs, ... }:
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
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
      local function fugitive_commit_and_push()
        if vim.fn.finddir('.git', '.;') ~= "" and vim.bo.buftype == "" then
          local filename = vim.fn.expand('%:t')
          vim.cmd.Git('add -u')
          vim.cmd.Git('commit -m "auto push notes in ' .. filename .. '"')
          vim.cmd.Git('push')
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
        callback = fugitive_pull_check, -- Corrected to use the unified pull function
        desc = 'auto git pull on neovim startup if in target dir'
      })
      
      vim.api.nvim_create_autocmd({ 'DirChanged' }, {
        group = augroup,
        pattern = '*', 
        callback = fugitive_pull_check, -- Corrected to use the unified pull function
        desc = 'auto git pull on entering the notes dir'
      })
      
      vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
        group = augroup,
        pattern = pattern,
        callback = fugitive_commit_and_push,
        desc = 'auto git commit & push on file save in notes dir'
      })
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
        formatters_by_ft = {
          nix = [ "nixpkgs_fmt" ];
          go = [ "gofmt" "goimports" ];
          javascript = [ "prettier" ];
          javascriptreact = [ "prettier" ];
          html = [ "prettier" ];
          css = [ "prettier" ];
          markdown = [ "prettier" ];
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

        marksman = {
          # markdown
          enable = true;
          onAttach.override = true;
          onAttach.function = ''
            -- Supress specific marksman errors
            -- TODO this only works after I run :e once
            local ignore_patterns = { "Link to non%-existant document" }
            local keep = function(d)
            for _, pat in ipairs(ignore_patterns) do
            if d.message:find(pat) then return false end
            end
            return true
            end

            -- Wrap future diagnostics
            local og_handler = vim.lsp.handlers["textDocument/publishDiagnostics"]
            vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
            if result then result.diagnostics = vim.tbl_filter(keep, result.diagnostics or {}) end
            og_handler(err, result, ctx, cfg)
            end
          '';
        };

        rust_analyzer = {
          # rust
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
      settings.auto_install = true;
    };

    plugins.web-devicons.enable = true;

    keymaps = [
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
    ];
  };
}

