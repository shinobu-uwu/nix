{inputs, ...}: {
  imports = [
    inputs.nixvim.homeModules.nixvim
    inputs.noctalia.homeModules.default
    inputs.niri.homeModules.niri
    inputs.plugged.homeManagerModules.default

    ./core.nix
    ./packages.nix
    ./services.nix
    ./desktop/appearance.nix
    ./desktop/niri.nix
    ./desktop/noctalia.nix
    ./programs/development.nix
    ./programs/nixvim.nix
    ./programs/shells.nix
    ./programs/terminals.nix
  ];
}
