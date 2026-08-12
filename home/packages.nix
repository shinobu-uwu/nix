{pkgs, ...}: {
  home.packages = with pkgs; [
    # Desktop applications and media
    bluetui
    feh
    firefox
    ffmpegthumbnailer
    gimp
    google-chrome
    impala
    insync
    krita
    mediainfo
    pavucontrol
    seahorse
    stremio-linux-shell
    sxiv
    via
    yt-dlp

    # Chat
    qt6.qtwayland
    vesktop
    zapzap

    # Command-line utilities
    bat
    bitwarden-cli
    btop
    curl
    eza
    fd
    glmark2
    jump
    killall
    libsecret
    linuxHeaders
    lm_sensors
    lshw
    openssl
    playerctl
    rclone
    ripgrep
    speedtest-cli
    sqlite
    tree
    unzip
    unrar
    usbutils
    vim
    wget
    wl-clipboard
    zip

    # Virtualization and system administration clients
    efibootmgr
    lact
    qemu
    quickemu
    sbctl
    spice-gtk
    virt-manager
  ];

  programs = {
    fastfetch = {
      enable = true;
      settings = {
        logo = {
          source = "nixos";
          padding = {
            top = 2;
            right = 2;
          };
        };
        display = {
          separator = " : ";
          color.keys = "magenta";
        };
        modules = [
          {
            type = "title";
            format = " {user-name} @ {host-name}";
          }
          "break"
          {
            type = "chassis";
            key = "╭─󰌢 Chassis ";
            keyColor = "green";
          }
          {
            type = "os";
            key = "├─󱄅 OS      ";
            keyColor = "blue";
          }
          {
            type = "kernel";
            key = "├─󰒔 Kernel  ";
            keyColor = "magenta";
          }
          {
            type = "packages";
            key = "├─󰏖 Packages";
            keyColor = "yellow";
          }
          {
            type = "display";
            key = "├─󰍹 Display ";
            keyColor = "blue";
          }
          {
            type = "terminal";
            key = "├─󰆍 Terminal";
            keyColor = "cyan";
          }
          {
            type = "wm";
            key = "╰─󱂬 WM      ";
            keyColor = "blue";
          }
          "break"
          {
            type = "cpu";
            key = "╭─󰻠 CPU     ";
            keyColor = "blue";
          }
          {
            type = "gpu";
            key = "├─󰢮 GPU     ";
            keyColor = "cyan";
          }
          {
            type = "memory";
            key = "├─󰍛 Memory  ";
            keyColor = "magenta";
          }
          {
            type = "uptime";
            key = "╰─󱎫 Uptime  ";
            keyColor = "red";
          }
          "break"
          {
            type = "colors";
            symbol = "circle";
          }
        ];
      };
    };

    mpv = {
      enable = true;
      scripts = [pkgs.mpvScripts.mpris];
    };

    prismlauncher.enable = true;
  };
}
