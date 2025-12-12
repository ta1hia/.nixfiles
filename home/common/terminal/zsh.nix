{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autocd = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      v = "nvim -p";
      mkdir = "mkdir -pv";
      rm = "rm -i";
      ll = "ls -AlFh";
      ls = "ls -lhg --color=always";
      l = "LC_COLLATE=C ls -C";
      la = "ls -A";
      notes = "cd ~/docs/notes && v";
      nixfiles = "cd ~/.nixfiles";

      # git aliases
      gs = "git status";
      gc = "git commit";
      gd = "git diff";
      gl = "git log";
    };

    initContent = ''
      bindkey '^R' history-incremental-search-backward

      export PS1="%F{yellow}%B%n %F{magenta}%1~ %b%f$ "

      termguicolors () {
        for i in {0..255}; do
          printf "\e[38;5;%sm%03d " "$i" "$i"
          if (( (i + 1) % 16 == 0 )); then
            echo
          fi
        done
        echo
      }
    '';
  };

  home.packages = with pkgs; [
    zsh
  ];
}
