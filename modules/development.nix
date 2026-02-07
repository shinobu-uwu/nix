{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    (pkgs.rust-bin.nightly.latest.default.override {
      extensions = [ "rust-src" "clippy" "rustfmt" "rust-analyzer" ];
    })
    go
    python3
    lua
    luarocks
    bun
    nodejs
    lazygit
    gh
    gdb
    xh
  ];
}
