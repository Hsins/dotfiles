<!-- badges -->
<div align="right">

  [![README in Traditional Chinese](https://img.shields.io/badge/README-繁體中文-8CA1AF.svg?logo=read-the-docs&style=flat-square)](./README_zh-TW.md)
  [![](https://img.shields.io/github/license/Hsins/Portfolio.svg?style=flat-square)](./LICENSE)

</div>

<!-- logo, title and description -->
<div align="center">

  <img src="https://i.imgur.com/U8UKFdM.png" alt="dotfiles" height="150px" />

# Dotfiles

⚙ _Hsins' configuration files (dotfiles, like `~/.zshrc`) across multiple devices, compatible with macOS, Windows, and Linux operating systems._

[![Windows](https://img.shields.io/badge/Windows-%23.svg?style=flat-square&logo=windows&color=0078D6&logoColor=white)]()
[![Linux](https://img.shields.io/badge/Linux-%23.svg?style=flat-square&logo=linux&color=FCC624&logoColor=black)]()
[![macOS](https://img.shields.io/badge/macOS-%23.svg?style=flat-square&logo=apple&color=000000&logoColor=white)]()

</div>

## Overview

- Follow [XDG Base Directory Specification (XDGDG)](https://wiki.archlinux.org/title/XDG_Base_Directory).

## Screenshots

<div align="center">
  <img src="https://i.imgur.com/JbnSLom.png" alt="Microsoft Windows Screenshot">
</div>

## Setup

```bash
$ bash -c "$(curl -LsS https://raw.github.com/Hsins/dotfiles/main/os/setup.sh)"
$ bash -c "$(wget -qO - https://raw.github.com/Hsins/dotfiles/main/os/setup.sh)"
```

## Supported Toolset

### Shells

- bash: [`~/shells/bash`](./shells/bash)
- PowerShell: [`~/shells/pwsh`](./shells/pwsh) _<sup>enhanced with [**Oh-My-Posh**](https://github.com/JanDeDobbeleer/oh-my-posh), [**Terminal Icons**](https://github.com/devblackops/Terminal-Icons), and others!</sup>_
- zsh: [`~/shells/zsh`](./shells/zsh)

### Terminals

- iTerm2: [`~/.config/iterm2`](./.config/iterm2)
- Windows Terminal: [`~/.config/windows-terminal`](./.config/windows-terminal)

### Universal Applications

- aria2: [`~/.config/aria2`](./.config/aria2)
- Git: [`~/.config/git`](./.config/git)
- Helm: The package manager for Kubernetes. [`~/.config/helm`](./.config/helm)
- htop: An interactive process viewer. [`~/.config/htop`](./.config/htop/htoprc)
- OpenSSH
- tmux: [`~/.config/tmux`](./config/tmux)
- Vim/Neovim

## Inspirations

- [gf3/dotfiles | GitHub](https://github.com/gf3/dotfiles)
- [alrra/dotfiles | GitHub](https://github.com/alrra/dotfiles)
- [tshu-w/dotfiles | GitHub](https://github.com/tshu-w/dotfiles)
- [renemarc/dotfiles | GitHub](https://github.com/renemarc/dotfiles)

## References

- [GitHub | DotFile](https://dotfiles.github.io/)

## License

Licensed under the MIT License, Copyright © 2017-present Hsins.

<p align="center">
  <sub>Assembled with ❤️ in Taiwan.</sub>
</p>