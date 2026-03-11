# Dotfiles

## Dependencies

- [Ghostty](https://ghostty.org/) - Terminal emulator
- [A Nerd Font](https://www.nerdfonts.com/)
- [Rust](https://rustup.rs/)
- [nvm](https://github.com/nvm-sh/nvm)
- [tpm](https://github.com/tmux-plugins/tpm) - Tmux Plugin Manager

## Installation

### With Nix

> The repo path is hardcoded in `nix/home.nix`. Clone to `~/dev/dotfiles` or update the path before switching.

Install [Nix](https://nixos.org/download/), then:

```sh
git clone --recurse-submodules https://github.com/cyuanli/dotfiles.git ~/dev/dotfiles
nix run home-manager/master -- switch --flake ~/dev/dotfiles/nix#cyl
```

Dotfile changes take effect immediately, no need to re-run `home-manager switch` after editing a config file.

### Without Nix

Install [GNU Stow](https://www.gnu.org/software/stow/), [Neovim](https://neovim.io/) (to `/opt/nvim-linux-x86_64/`), [Starship](https://starship.rs/), [tmux](https://github.com/tmux/tmux), and [Git](https://git-scm.com/), then:

```sh
git clone --recurse-submodules https://github.com/cyuanli/dotfiles.git <path>
cd <path>
stow -v -t ~ bash git tmux ghostty nvim starship
```
