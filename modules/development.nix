{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    python3
    lua
    bun
    nodejs
    lazygit
    gh
    gdb
    xh
    opencode
    cargo-generate
    jetbrains.rider
    hyperfine
    codex
    llmfit
    ollama
    jq
  ];
}
