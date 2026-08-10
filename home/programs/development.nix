{
  lib,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Matheus Filipe dos Santos Reinert";
        email = "matheus.reinert@protonmail.com";
      };
      init.defaultBranch = "main";
    };
  };

  home.packages = with pkgs; [
    bun
    cargo-generate
    (lib.lowPrio clang)
    codex
    (lib.hiPrio gcc)
    gdb
    gh
    gnumake
    hyperfine
    jq
    lazygit
    llmfit
    lua
    nodejs
    ollama
    opencode
    python3
    rust-bin.stable.latest.default
    xh
  ];
}
