# How To Use

- [Install `nix`](<https://nixos.org/download/#download-nix:~:text=sh%20%3C(curl%20%2D%2Dproto%20%27%3Dhttps%27%20%2D%2Dtlsv1.2%20%2DL%20https%3A//nixos.org/nix/install)>)
- Clone the repository
- Clone the repo
- [Install home-manager](https://nix-community.github.io/home-manager/)
- Run home manager switch

```bash
cd "<repo-name>"
home-manager switch --flake .#ikan-yeyee-mac
```

\*Note: Currently only has Mac configuration, linux will be coming soon.

# Capabilities

- Tmux
  - Rose Pine theme
  - Tmux Resurrect for session saving capabilities
  - Sane & logical keybinding
- Neovim (if you want my configuration, [here it is](https://github.com/yeyee2901/ikan-yeye-nvim)), I use LazyVim
- Golang development
- Lazygit (TUI for git)
- fzf
- zoxide for `cd` & better experience with `cd` fuzzy finding

```nix
home.packages = with pkgs; [
  go
  nodejs
  lazygit
  fzf
  rustc
  python312
];
```
