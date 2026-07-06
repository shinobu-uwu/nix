# Repository Guidelines

## Project Structure & Module Organization

This repository is a NixOS flake for the `nixos` host and the `shinobu` Home Manager profile. `flake.nix` defines inputs, overlays, `nixosConfigurations.nixos`, and `homeConfigurations."shinobu"`. System entry points live in `configuration.nix` and `hardware-configuration.nix`. Reusable system modules are in `modules/` (`system.nix`, `niri.nix`, `development.nix`, `chat.nix`, `games.nix`). User-level configuration is concentrated in `home.nix`. Small runtime assets, such as notification sounds for `plugged`, are in `assets/`.

## Build, Test, and Development Commands

- `nix flake check`: evaluate flake outputs and catch basic evaluation errors.
- `nix build .#nixosConfigurations.nixos.config.system.build.toplevel`: build the system closure without switching to it.
- `sudo nixos-rebuild switch --flake .#nixos`: apply the NixOS configuration to the local host.
- `nix run nixpkgs#home-manager -- switch --flake .#shinobu`: apply the Home Manager profile.
- `nix flake update`: update pinned inputs in `flake.lock`; review the lockfile diff before committing.

## Coding Style & Naming Conventions

Use idiomatic Nix with two-space indentation, small attribute sets, and trailing semicolons. Keep host-wide settings in `configuration.nix` or `modules/`; keep user packages, services, Niri bindings, and editor setup in `home.nix`. Name modules by domain, for example `modules/development.nix`. Prefer `with pkgs; [ ... ]` for package lists only when it improves readability. Format Nix files with `alejandra` when available, for example `nix run nixpkgs#alejandra -- .`.

## Testing Guidelines

There is no separate test suite. Treat Nix evaluation and dry builds as the required checks. Run `nix flake check` after structural changes, and build the affected output before switching. For hardware, boot, display manager, or shell changes, prefer building first and only then running `nixos-rebuild switch`.

## Commit & Pull Request Guidelines

Recent commits use very short uppercase or keyword summaries such as `MORE`, `NEOVIM`, and `JQ`. Keep summaries concise, but use a more descriptive subject when possible, such as `niri: adjust portal defaults` or `home: add formatter config`. Pull requests should describe the affected area, list validation commands run, call out lockfile updates, and mention any manual checks after switching.

## Security & Configuration Tips

Do not commit secrets, tokens, private keys, or machine-specific credentials. Be careful with `hardware-configuration.nix`, bootloader settings, user groups, and `allowUnfree`; changes there affect the whole machine. Keep generated build outputs and local result symlinks out of commits.
