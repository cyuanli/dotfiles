{ config, pkgs, ... }:
let
  dotfiles = "${config.home.homeDirectory}/dev/dotfiles";
in {
  home.username = "cyl";
  home.homeDirectory = "/home/cyl";
  home.stateVersion = "25.11";

  home.packages = [
    pkgs.htop
    pkgs.mako
    pkgs.neovim
    pkgs.starship
    pkgs.tmux
    pkgs.tree-sitter
    pkgs.waybar
    pkgs.wofi
    pkgs.yazi
    pkgs.zoxide
  ];

  home.file = {
    ".config/home-manager".source  = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/nix";
    ".bashrc".source               = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/bash/.bashrc";
    ".bash_aliases".source         = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/bash/.bash_aliases";
    ".zshrc".source                = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/zsh/.zshrc";
    ".zshenv".source               = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/zsh/.zshenv";
    ".gitconfig".source            = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/git/.gitconfig";
    ".tmux.conf".source            = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/tmux/.tmux.conf";
    ".config/nvim".source          = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/nvim/.config/nvim";
    ".config/ghostty".source       = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/ghostty/.config/ghostty";
    ".config/starship.toml".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/starship/.config/starship.toml";
    ".config/alacritty".source     = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/alacritty/.config/alacritty";
    ".config/mako".source          = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/mako/.config/mako";
    ".config/sway".source          = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/sway/.config/sway";
    ".config/waybar".source        = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/waybar/.config/waybar";
    ".config/wofi".source          = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/wofi/.config/wofi";
  };

  programs.home-manager.enable = true;
}
