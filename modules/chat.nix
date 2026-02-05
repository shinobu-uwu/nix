{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ vesktop zapzap qt6.qtwayland ];
}
