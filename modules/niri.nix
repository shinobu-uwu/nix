{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    waybar
    fuzzel
    mako
    swaybg
    swayidle
    dracula-theme
    dracula-icon-theme
    bibata-cursors
    xwayland-satellite
  ];
}
