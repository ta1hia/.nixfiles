{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    clock24 = true;
    plugins = with pkgs; [
        #tmuxPlugins.continuum
        tmuxPlugins.resurrect
    ];
    sensibleOnTop = false;
    extraConfig= '' # used for less common options, intelligently combines if defined in multiple places.
# panes
set -g pane-border-style 'fg=colour240 bg=colour0'
set -g pane-active-border-style 'bg=colour0 fg=colour245'

# statusbar
set -g status-position bottom
set -g status-style 'bg=colour235 fg=colour28 dim'
    ''; 
  };
}
