{
  description = "IXUI - an Incus web UI packaged as a drop-in replacement for incus-ui-canonical";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    let
      # Replacing the stock UI package this way also changes the default of
      # `virtualisation.incus.ui.package` used by the NixOS incus module.
      overlay = final: prev: {
        ixui = final.callPackage ./package.nix { };
        incus-ui-canonical = final.ixui;
      };
    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ overlay ];
        };
      in
      {
        packages = {
          ixui = pkgs.ixui;
          default = pkgs.ixui;
        };

        devShells.default = pkgs.mkShell {
          packages = [ pkgs.nodejs ];
        };
      }
    )
    // {
      overlays.default = overlay;

      # Opt in with `inputs.ixui.nixosModules.default`.
      nixosModules.default = { ... }: {
        nixpkgs.overlays = [ overlay ];
      };
    };
}
