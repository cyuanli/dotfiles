{ config, pkgs, ... }:
let
  dotfiles = "${config.home.homeDirectory}/dev/dotfiles";
in {
  home.username = "cyl";
  home.homeDirectory = "/home/cyl";
  home.stateVersion = "25.11";

  home.packages = [
    pkgs.gcc
    pkgs.htop
    pkgs.neovim
    pkgs.starship
    pkgs.tmux
    pkgs.tree-sitter
  ];

  home.file = {
    ".config/home-manager".source   = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/nix";
    ".bashrc".source                = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/bash/.bashrc";
    ".bash_aliases".source          = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/bash/.bash_aliases";
    ".gitconfig".source             = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/git/.gitconfig";
    ".tmux.conf".source             = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/tmux/.tmux.conf";
    ".config/nvim".source           = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/nvim/.config/nvim";
    ".config/ghostty/config".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/ghostty/.config/ghostty/config";
    ".config/starship.toml".source  = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/starship/.config/starship.toml";
  };

  programs.home-manager.enable = true;
}
