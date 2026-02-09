{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
    ripgrep
    wget
    curl
    alacritty
    firefox
    google-chrome
    btop
    wl-clipboard
    gnumake
    gcc
    clang
    zip
    unzip
    mpv
    bat
    eza
    fd
    nh
    curl
    glmark2
    insync
    jump
    libsecret
    linuxHeaders
    lm_sensors
    lshw
    neofetch
    pavucontrol
    speedtest-cli
    sqlite
    tmux
    tree
    usbutils
    via
    openssl
    killall
    qemu
    virt-manager
    spice-gtk
    quickemu
    playerctl
    yt-dlp
    seahorse
  ];
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      font-awesome
      noto-fonts
      noto-fonts-color-emoji
      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only
      google-fonts
      corefonts
      freefont_ttf
      lexend
    ];

    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" ];
      sansSerif = [ "Lexend Deca" ];
      monospace = [ "JetBrainsMono Nerd Font" ];
    };
  };
}
