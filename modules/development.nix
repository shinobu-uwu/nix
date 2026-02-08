{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    (pkgs.rust-bin.nightly.latest.default.override {
      extensions = [ "rust-src" "clippy" "rustfmt" "rust-analyzer" ];
    })
    python3
    lua
    luarocks
    bun
    lazygit
    gh
    gdb
    xh
  ];
}
