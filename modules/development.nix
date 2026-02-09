{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    python3
    lua
    bun
    lazygit
    gh
    gdb
    xh
    opencode
  ];
}
