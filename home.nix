{ config, pkgs, ... }:

{
  # nix needs to know some basic info
  home.username = "yeyee2901";
  home.homeDirectory = "/Users/yeyee2901";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    go
    nodejs
    lazygit
    fzf
    rustc
    python312
  ];

  programs.home-manager.enable = true;
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "avit";
      plugins = [
        "git"
        "golang"
        "tmux"
        "fzf"
        "colored-man-pages"
        "command-not-found"
      ];
    };

    shellAliases = {
      ll = "ls -l";
      la = "ls -la";
      lg = "lazygit";
      vi = "nvim";
      vim = "nvim";
    };

    initContent = ''
    # PATHS environment variable
    export PATH=$PATH:/opt/homebrew/bin
    export PATH=$PATH:$HOME/go/bin
    export PATH=$PATH:$HOME/bin

    # PATH for npm
    export NPM_PACKAGES=$HOME/.npm-packages
    export NODE_PATH=$NPM_PACKAGES/lib/node_modules:$NODE_PATH
    export PATH=$NPM_PACKAGES/bin:$PATH

    # aliases
    export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
    export PATH=$PATH:/opt/homebrew/Cellar/openvpn/2.6.0/sbin

    echo "prefix=$HOME/.npm-packages" > $HOME/.npmrc
    '';
  };

  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    keyMode = "vi";
    mouse = true;
    
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = resurrect;
      }
      {
        plugin = rose-pine;
        extraConfig = ''
          # Options are 'main', 'moon' or 'dawn'
          set -g @rose_pine_variant 'moon'

          # Disables background color, for transparent terminal emulators
          set -g @rose_pine_bar_bg_disable 'on'

          # Enables hostname in the status bar
          set -g @rose_pine_host 'off'

          # Turn on the username component in the statusbar
          set -g @rose_pine_user 'off'

          # Turn on the current folder component in the status bar
          set -g @rose_pine_directory 'off'

          # Disables the menu that shows the active window on the left
          set -g @rose_pine_disable_active_window_menu 'on'

          # It accepts the date UNIX command format (man date for info)
          set -g @rose_pine_date_time '%Y-%m-%d %H:%M'
        '';
      }
    ];
    
    extraConfig = ''
    #######################
    # TRUE COLOR SETTINGS #
    #######################
    set -g default-terminal "screen-256color"
    set -ag terminal-overrides ",xterm-256color:RGB"

    #########################
    # BASIC SETTINGS        #
    #########################
    # disable multiple leader repeats
    set-option -g repeat-time 0

    # set status line to be on top
    set-option -g status-position top

    # set numbering to base 1 index (more friendly)
    set -g base-index 1
    setw -g pane-base-index 1

    # to avoid <ESC> delay in neovim
    set -sg escape-time 0

    # Set pane char, only works with tmux >3.2
    # single, double, heavy, simple, number
    setw -g pane-border-lines "double"
    setw -g pane-border-style "fg=magenta bg=magenta"

    # Enable mouse
    set -g mouse on

    # Enable vim mode keybinding in copy mode
    # 1. Enter Copy mode :      <prefix> [
    # 2. Begin visual:          v (to toggle VISUAL-BLOCK, press Ctrl+v)
    # 3. Copy:                  y
    # also provides automatic clipboard sync for macOS & linux
    # If you're using iTerm, do not forget to turn on the clipboard permission under:
    # 'General' > 'Selection' > 'Application in terminals may access clipboard'
    setw -g mode-keys vi
    set-option -s set-clipboard on
    bind-key -T copy-mode-vi v send-keys -X begin-selection
    bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
    unbind -T copy-mode-vi ENTER
    if-shell "uname | grep -q Darwin" {
      bind-key -T copy-mode-vi 'y' send -X copy-pipe-and-cancel 'reattach-to-user-namespace pbcopy'
      bind-key -T copy-mode-vi Enter send -X copy-pipe-and-cancel 'reattach-to-user-namespace pbcopy'
    } {
      bind-key -T copy-mode-vi 'y' send -X copy-pipe-and-cancel 'xclip -in -selection clipboard'
      bind-key -T copy-mode-vi Enter send -X copy-pipe-and-cancel 'xclip -in -selection clipboard'
    }


    #########################
    # KEYBINDINGS           #
    #########################
    # Change refix to <C-Space>
    unbind-key C-b
    set-option -g prefix C-Space
    bind-key C-Space send-prefix

    # Pane splitting
    # a bit confusion here, -h will split the pane
    # with this layout -> o|o
    # while -v         -> =
    # And also open split in the same directory
    unbind '"'
    unbind %
    unbind C-h
    bind -r v split-window -h -c "#{pane_current_path}"
    bind -r h split-window -v -c "#{pane_current_path}"

    # open new window in same directory
    bind c new-window -c "#{pane_current_path}"

    # Vim like pane movement (prefix<C-hjkl>)
    bind -r C-h select-pane -L
    bind -r C-j select-pane -D
    bind -r C-k select-pane -U
    bind -r C-l select-pane -R

    # toggle statusline
    bind C-t set-option status

    # resizing
    bind-key -r -T prefix       S-Up              resize-pane -U
    bind-key -r -T prefix       S-Down            resize-pane -D
    bind-key -r -T prefix       S-Left            resize-pane -L
    bind-key -r -T prefix       S-Right           resize-pane -R


    ################################
    # POP UP MENU QUALITY OF LIFE  #
    ################################
    bind-key C-i display-popup \
      -d "#{pane_current_path}" \
      -w 80% \
      -h 80% \
      -E "claude"

    # spawn a lazygit
    bind-key C-g display-popup \
      -d "#{pane_current_path}" \
      -w 80% \
      -h 80% \
      -E "lazygit"

    # spawn a floating terminal
    bind-key C-t display-popup \
      -d "#{pane_current_path}" \
      -w 80% \
      -h 80% \
      -E "$SHELL"

    bind-key C-f display-popup \
      -w 80% \
      -h 80% \
      -E "tmux new-window -c $(find ~ -type d -print | fzf --prompt 'Open a file in a new window:')"
    '';
  };

  programs.neovim = {
    enable = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "find . -type f";
    defaultOptions = [
      "--height 40%"
      "--border"
      "--reverse"
    ];
  };
}
