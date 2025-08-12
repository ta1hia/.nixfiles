{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;

    clock24 = true;
    keyMode = "vi";
    escapeTime = 1;
    plugins = with pkgs; [
        tmuxPlugins.resurrect
    ];
    sensibleOnTop = false;

    extraConfig= ''
# used for less common options, intelligently combines if defined in multiple places.

# panes
set -g pane-border-style 'fg=colour240'
set -g pane-active-border-style 'fg=colour245'
set -g pane-base-index 1

# statusbar
set -g status-position bottom
set -g status-justify centre
set -g status-style 'fg=colour28 dim'
setw -g monitor-activity on
setw -g window-status-activity-style 'fg=colour160'
set -g visual-activity on

# windows
setw -g base-index 1

# broadcast command
bind A setw synchronize-panes
setw -g window-status-current-format '#{?pane_synchronized,#[bg=red],}#I:#W'
setw -g window-status-format         '#{?pane_synchronized,#[bg=red],}#I:#W'

# copy mode
bind-key -T copy-mode-vi 'v' send-keys -X begin-selection     # begin selection
bind-key -T copy-mode-vi 'C-v' send-keys -X rectangle-toggle  # begin rectangle selection (C-v + Space)
bind-key -T copy-mode-vi 'y' send-keys -X copy-selection      # yank selection

# system clipboard (xclip)
bind-key -T copy-mode-vi 'Y' send-keys -X copy-pipe-and-cancel "xclip -i -sel clipboard"
bind C-v run "tmux set-buffer \"$(xclip -o -sel clipboard)\"; tmux paste-buffer"

# reload
bind r source-file ~/.config/tmux/tmux.conf \; display "reloaded from ~/.config/tmux/tmux.conf :)"

set -g default-terminal "tmux-256color"
    ''; 
  };
}
