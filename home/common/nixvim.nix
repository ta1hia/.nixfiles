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

    globals.mapleader = ",";

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

      " misc
      " set number
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
    ];
  };
}
