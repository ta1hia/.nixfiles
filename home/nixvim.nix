{ inputs, pkgs, ... }:
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

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
        pyright.enable = true; # python
        gopls.enable = true; # go
        nixd.enable = true; # nix
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

    plugins.cmp-nvim-lsp.enable = true;

    keymaps = [
      {
        mode = "n";
        key = "=";
        action = "<cmd>lua require('conform').format({ async = true, lsp_fallback = true })<cr>";
        options = { silent = true; };
      }
      {
        mode = "v";
        key = "=";
        action = "<cmd>lua require('conform').format({ async = true, lsp_fallback = true })<cr>";
        options = { silent = true; };
      }
    ];

  };
}
