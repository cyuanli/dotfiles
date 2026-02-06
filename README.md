# Dotfiles

## Dependencies

- [GNU Stow](https://www.gnu.org/software/stow/) - Symlink manager
- [Ghostty](https://ghostty.org/) - Terminal emulator
- [Neovim](https://neovim.io/) - Text editor (install to `/opt/nvim-linux-x86_64/`)
- [Starship](https://starship.rs/) - Shell prompt
- [tmux](https://github.com/tmux/tmux) - Terminal multiplexer
- [tpm](https://github.com/tmux-plugins/tpm) - Tmux Plugin Manager
- [Git](https://git-scm.com/)
- [Rust](https://rustup.rs/)
- [nvm](https://github.com/nvm-sh/nvm)
- [A Nerd Font](https://www.nerdfonts.com/)

## Installation

```sh
git clone --recurse-submodules <repo-url>
cd dotfiles
stow -v -t ~ bash git tmux ghostty nvim starship
```
