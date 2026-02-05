{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    wineWowPackages.stable
    wineWowPackages.staging
    winetricks
    wineWowPackages.waylandFull
    steam
    gamemode
  ];

  programs.gamemode.enable = true;
  programs.steam.extraCompatPackages = with pkgs; [ proton-ge-bin ];
}
