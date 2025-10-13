# .nixfiles

This is my flake-based NixOS and nix-darwin system configs, with home-manager added as a module for user-level configs. My goal was to maintain a consistent and reproducible development environment across multiple machines (currently: a linux laptop running NixOS, a macOS machine) using a single, multi-platform Nix flake.

Extended tahia vs. nix journey documented [here](https://computers.lol/posts/2024-02-02-migrating-channels-to-flakes/).

## Features

- **multi-platform support**: a single `flake.nix` file manages configurations for both nixos and nix-darwin

- **declarative configuration**: all system packages, dotfiles, and user settings are managed declaratively using Nix

- **shared home-manager modules**: common settings and packages like nixvim, zsh, and tmux are shared between hosts through the home/common directory

- **host-specific overrides**: each machine has its own directory under `hosts` for hardware-specific settings and system services

- **secrets management**: secrets are managed using sops-nix

## How to Deploy

### First-Time Setup (NixOS)

Clone this repository to `~/.nixfiles`. Then:

```
sudo nixos-rebuild switch --flake .#lolbox
```

## First-Time Setup (macOS)

Install [Determinate Nix](https://docs.determinate.systems/determinate-nix/) and clone this repo to `~/.nixfiles`.

Run the following command to build and activate the nix-darwin system profile and fix directory permissions from using sudo. sudo is necessary for system-level changes.

```
sudo nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake .#pz-macbook
sudo chown -R tahia:staff /Users/tahia/.local
```

Once the command finishes, `darwin-rebuild` will be available in your shell.

### Updating Your Configuration

After the initial setup, you can update your configurations with the following commands.

NixOS: `sudo nixos-rebuild switch --flake .#lolbox`

darwin: `sudo darwin-rebuild switch --flake .#pz-macbook`

This builds a new system generation and creates a symlink to it, including the activation step for home-manager since it's configured as a module.
