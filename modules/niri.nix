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
    obs-studio
    nautilus
  ];

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vaapi
      obs-gstreamer
      obs-vkcapture
      obs-move-transition
      obs-multi-rtmp
    ];
  };
  xdg.portal = {
    enable = true;
    extraPortals =
      [ pkgs.xdg-desktop-portal-gnome pkgs.xdg-desktop-portal-gtk ];
    config = {
      common.default = [ "gtk" ];
      niri.default = [ "gnome" "gtk" ];
    };
  };
}
