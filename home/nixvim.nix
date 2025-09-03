{ inputs, pkgs, ... }:
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
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
    '';

    extraPackages = with pkgs; [
      nixpkgs-fmt
    ];

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
        };
      };
    };

    # language servers
    plugins.lsp = {
      enable = true;
      servers = {
        bashls.enable = true; # bash
        gopls.enable = true; # go
        marksman.enable = true; # markdown
        nixd.enable = true; # nix
        pyright.enable = true; # python
        ts_ls.enable = true; # js/typescript

        rust_analyzer = {
          # rust
          enable = true;
          installRustc = true;
          installCargo = true;
        };

      };
    };

    # completion plugin
    plugins.cmp-nvim-lsp.enable = true;
    plugins.cmp = {
      enable = true;
      autoEnableSources = true;

      settings.sources = [
        { name = "nvim_lsp"; }
        { name = "path"; }
        { name = "buffer"; }
        { name = "luasnip"; }
      ];

      settings.mapping = {
        "<Tab>" = "cmp.mapping.select_next_item()"; # select next item on tab
        "<S-Tab>" = "cmp.mapping.select_prev_item()"; # select previous item on shift+tab
        "<CR>" = "cmp.mapping.confirm({ select = true })"; # accept selected completion on enter
      };
    };

    # obsidian.vim
    plugins.obsidian = {
      enable = true;

      settings = {
        ui = {
          enable = true;
        };

        workspaces = [
          {
            name = "notes";
            path = "~/docs/notes";
          }
        ];

        note_id_func = ''
          function(title)
            -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
            -- In this case a note with the title 'My new note' will be given an ID that looks
            -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
            local suffix = ""
            if title ~= nil then
              -- If title is given, transform it into valid file name.
              suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
            else
              -- If title is nil, just add 4 random uppercase letters to the suffix.
              for _ = 1, 4 do
                suffix = suffix .. string.char(math.random(65, 90))
              end
            end
            return tostring(os.time()) .. "-" .. suffix
          end
        '';

        note_path_func = ''
          function(spec)
            local path = spec.dir / tostring(spec.title)
            return path:with_suffix(".md")
          end
        '';

        follow_url_func = ''
          function(url)
            -- Open the URL in the default web browser.
            vim.fn.jobstart({"xdg-open", url})  -- linux
          end
        '';
      };
    };

    # fuzzy-finder
    plugins.telescope = {
      enable = true;
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
        key = "<leader>e";
        action = "<cmd>lua vim.diagnostic.open_float()<cr>";
        options = { desc = "show full diagnostic text on an annotated line"; };
      }
    ];

  };
}
