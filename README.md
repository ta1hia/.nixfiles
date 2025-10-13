# .nixfiles

flake-based NixOS system configs + home-manager added as a NixOS module for user-level configs

the journey documented [here](https://computers.lol/posts/2024-02-02-migrating-channels-to-flakes/)

```
# first time
sudo nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake .#pz-macbook
sudo chown -R tahia:staff /Users/tahia/.local

# all other times
sudo darwin-rebuild switch --flake .#pz-macbook
```

