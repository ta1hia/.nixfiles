# turning nixvim off for now, using programs.neovim instead to get a better feel of neovim configs
# as i'm learning. TODO possibly switch to nixvim eventually when my neovim config settles.

{ inputs, ... }:
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = {
    enable = false;		
    defaultEditor = false;
  };
}
