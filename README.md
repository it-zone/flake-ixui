# flake-ixui

Packages [ixui](https://github.com/xlmnxp/ixui) — an Incus web UI — for NixOS as
a drop-in replacement for [`pkgs.incus-ui-canonical`](https://github.com/NixOS/nixpkgs/blob/master/pkgs/by-name/in/incus-ui-canonical/package.nix).

The derivation builds the Vite app from source with `npmDepsHash` (offline,
reproducible) and installs the contents of `dist/` at the root of the output,
which is the layout `incusd` expects from its `INCUS_UI` environment variable.
Assets use the `/ui/` base path, matching the stock Incus UI.

## Usage

### Overlay (recommended)

Replacing the `incus-ui-canonical` attribute makes the stock NixOS option
`virtualisation.incus.ui.package` pick up ixui automatically:

```nix
{
  inputs.ixui.url = "github:it-zone/flake-ixui";

  nixpkgs.overlays = [ inputs.ixui.overlays.default ];

  virtualisation.incus.enable = true;
  virtualisation.incus.ui.enable = true;
}
```

### NixOS module

The same effect can be opted into through the provided module:

```nix
{
  inputs.ixui.url = "github:it-zone/flake-ixui";

  imports = [ inputs.ixui.nixosModules.default ];

  virtualisation.incus.enable = true;
  virtualisation.incus.ui.enable = true;
}
```

### Direct package

```sh
nix build .#ixui
```

Then set the package explicitly:

```nix
{
  virtualisation.incus.ui.package = inputs.ixui.packages.${pkgs.system}.ixui;
}
```

## Updating

Bump `version`, `src.hash` and `npmDepsHash` in `package.nix`. The `src` hash
can be obtained with:

```sh
nix-prefetch-url --unpack https://github.com/xlmnxp/ixui/archive/refs/tags/v<version>.tar.gz
```
