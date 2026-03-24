{
  config,
  pkgs,
  inputs,
  ...
}:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "pn";
  home.homeDirectory = "/home/pn";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # dev
    git
    curl
    go
    gopls
    rustup
    nixd
    nixpkgs-fmt
    nil
    gcc
    gnumake
    fd
    lazygit
    tree-sitter
    cloudflared
    distrobox
    procps
    gdb
    perl
    file
    podman
    llvmPackages_latest.libclang

    # term
    ripgrep
    bat
    zellij
    rofi
    btop
    fastfetch
    yazi
    zoxide
    fish
    starship
    unzip
    kdePackages.ark

    # compositor
    qt6Packages.qt6ct
    adwaita-qt
    wl-clipboard
    swayidle
  ];

  programs.fish = {
    enable = true;
    shellAbbrs = {
      rebuild = "home-manager switch --flake ~/homemanager#pn";
      ff = "fastfetch";
      lg = "lazygit";
      editconfig = "nvim ~/homemanager/home.nix";
      editflake = "nvim ~/homemanager/flake.nix";
      cd = "z";
      cdi = "zi";
    };
    loginShellInit = ''
      if test -f $HOME/.hm-session-vars.sh
        source $HOME/.hm-session-vars.sh
      end
    '';
    interactiveShellInit = ''
      set -g fish_greeting ""
      if test -e ~/.nix-profile/etc/profile.d/nix.fish
        source ~/.nix-profile/etc/profile.d/nix.fish
      end
    '';
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome-themes-extra;
    };
    cursorTheme = {
      name = "ShihoStatic";
      size = 64;
    };
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
  };

  programs.starship = {
    enable = true;
  };

  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        viAlias = true;
        vimAlias = true;
        autopairs.nvim-autopairs.enable = true;
        autocomplete.nvim-cmp.enable = true;
        snippets.luasnip.enable = true;

        lsp = {
          enable = true;
          formatOnSave = true; # Highly recommended for a clean workflow
        };

        theme = {
          enable = true;
          name = "tokyonight";
          style = "moon";
          transparent = true;
        };

        options = {
          autoindent = true; # Copy indent from current line when starting a new line
          smartindent = true; # Smart auto-indenting for programming
          shiftwidth = 2; # Number of spaces to use for each step of (auto)indent
          tabstop = 2; # Number of spaces that a <Tab> in the file counts for
          expandtab = true; # Use spaces instead of tabs
        };
        # Enable language support (this automatically installs the LSPs,
        # formatters, and Treesitter parsers for these languages)
        languages = {
          enableTreesitter = true;
          nix = {
            enable = true;
            format.type = [ "alejandra" ];
            lsp.servers = [ "nil" ];
          };
          go.enable = true;
          rust.enable = true;
        };

        telescope.enable = true;
        statusline.lualine.enable = true;
      };
    };
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    ".config/niri/start.sh" = {
      text = ''
        #!/bin/sh
        if [ -f "$HOME/.hm-session-vars.sh" ]; then
          . "$HOME/.hm-session-vars.sh"
        fi

        if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
          eval $(dbus-launch --sh-syntax --exit-with-session)
        fi
        exec niri
      '';
      executable = true;
    };
  };

  home.sessionVariables = {
    SUDO_EDITOR = "nvim";
    EDITOR = "nvim";
    GTK_THEME = "Adwaita:dark";
    XCURSOR_THEME = "ShihoStatic";
    XCURSOR_SIZE = "32";
  };

  home.sessionPath = [
    "$HOME/.nix-profile/bin"
    "$HOME/.local/bin"
  ];

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/pn/etc/profile.d/hm-session-vars.sh
  #
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
