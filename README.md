# .nixfiles

This is my flake-based NixOS and nix-darwin system configs, with home-manager added as a module for user-level configs. My goal was to maintain a consistent and reproducible development environment across multiple machines (currently: a linux laptop running NixOS, a macOS machine) using a single, multi-platform Nix flake.

Extended tahia vs. nix journey documented [here](https://computers.lol/posts/2024-02-02-migrating-channels-to-flakes/).

## Features

- Multi-Platform Support: A single `flake.nix` file manages configurations for both nixos and nix-darwin.

- Declarative Configuration: All system packages, dotfiles, and user settings are managed declaratively using Nix.

- Shared Home-Manager Modules: Common settings and packages like nixvim, zsh, and tmux are shared between hosts through the home/common directory.

- Host-Specific Overrides: Each machine has its own directory (hosts/lolbox and hosts/pz-macbook) for hardware-specific settings and system services.

- Secrets Management: Secrets are managed using sops-nix to securely handle sensitive data like network credentials.

## How to Deploy

### First-Time Setup (NixOS)

Clone this repository to `/home/tahia/.nixfiles`.

Run `nixos-rebuild switch --flake .#lolbox`.

## First-Time Setup (macOS)

Install [Determinate Nix](https://docs.determinate.systems/determinate-nix/) on your machine.

Clone this repository to `~/.nixfiles`.

Run the following command to build and activate the nix-darwin system profile. The sudo command is necessary for system-level changes.

```
sudo nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake .#pz-macbook
sudo chown -R tahia:staff /Users/tahia/.local

```

Once the command finishes, `darwin-rebuild` will be available in your shell.

### Updating Your Configuration

After the initial setup, you can update your configurations with the following commands.

NixOS: `nixos-rebuild switch --flake .#lolbox`

darwin: `sudo darwin-rebuild switch --flake .#pz-macbook`

This builds a new system generation and creates a symlink to it, including the activation step for home-manager.
