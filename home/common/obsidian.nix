{ pkgs, lib, ... }:

lib.mkMerge [
  (lib.mkIf pkgs.stdenv.isLinux {
    # 1. Installs the Obsidian application
    home.packages = [
      pkgs.obsidian
    ];

    xdg.enable = true;
    xdg.desktopEntries.obsidian = {
      name = "Obsidian";
      exec = "obsidian";
      icon = "obsidian";
      type = "Application";
      categories = [ "Office" "TextEditor" ];
    };

    programs.nixvim.plugins.obsidian = {
      enable = true;
      settings = {
        legacy_commands = false;
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
            local suffix = ""
            if title ~= nil then
              suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
            else
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
            vim.fn.jobstart({"xdg-open", url})  -- linux
          end
        '';
      };
    };
  })

  # (lib.mkIf pkgs.stdenv.isDarwin { ... }) # aspirational 
]
