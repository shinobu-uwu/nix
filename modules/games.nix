{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    wineWowPackages.stable
    wineWowPackages.staging
    winetricks
    wineWowPackages.waylandFull
  ];
}
