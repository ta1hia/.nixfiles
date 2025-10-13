{ config, pkgs, ... }:
{
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

  programs.nixvim = {
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
  };
}
