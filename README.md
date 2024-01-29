# Nix config including NixOS, home-manager and infrastructure using deploy-rs

## Starting

```bash
nix develop "github:iofq/nix"
```

## Nixos

### Building for local machine
```bash
nixos-rebuild switch --flake .#name
```
### Building remote hosts
```bash
nixos-rebuild switch --flake .#name --target-host host
```

### Building remote hosts using deploy-rs
```bash
nix develop
deploy .
```

## Home-manager

```bash
home-manager switch --flake "github:iofq/nix#t14"
```

## Developing

```
direnv allow
nix fmt
```

Direnv will also set up git pre-commit hooks to format the repo automatically.
