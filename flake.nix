{
  description = "NixOS Flake with Integrated Home Manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    niri.url = "github:sodiboo/niri-flake";
    alacritty-theme.url = "github:alexghr/alacritty-theme.nix";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, niri, home-manager, alacritty-theme, rust-overlay, ...
    }@inputs: {

      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          niri.nixosModules.niri
          ({ config, pkgs, ... }: {
            nixpkgs.overlays = [ alacritty-theme.overlays.default ];
          })
          ({ pkgs, ... }: {
            nixpkgs.overlays = [ rust-overlay.overlays.default ];
            environment.systemPackages =
              [ pkgs.rust-bin.stable.latest.default ];
          })
        ];
      };
      homeConfigurations."shinobu" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
          overlays =
            [ alacritty-theme.overlays.default rust-overlay.overlays.default ];
        };
        extraSpecialArgs = { inherit inputs; };
        modules = [ ./home.nix inputs.niri.homeModules.niri ];
      };
    };
}
