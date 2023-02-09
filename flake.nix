{
  description = "My awesome NixOS config uwu.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "nixpkgs/nixpkgs-22.11";
    nixpkgs-main.url = "github:NixOS/nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";

    private.url = "/home/pyrolagus/.config/dotfiles/private.flake";
    private.inputs.agenix.follows = "agenix";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, nixpkgs-stable, nixpkgs-main, nixpkgs-staging, home-manager, agenix, rust-overlay, private, ... }:
    let
      system = "x86_64-linux";
      unstable-overlay = final: prev: { unstable = nixpkgs-unstable.legacyPackages."${system}"; };
      stable-overlay = final: prev: { stable = nixpkgs-stable.legacyPackages."${system}"; };
      main-overlay = final: prev: { main = nixpkgs-main.legacyPackages."${system}"; };
      #factorio-overlay = final: prev: { factorio = prev.callPackage ./overlays/factorio { releaseType = "alpha"; }; };
      #mkUser = username: {
      #  home-manager.users."${username}" = (import ./home-manager/common.nix) // (import ./home-manager/users/"${username}");
      #};
    in
    {
      nixosConfigurations = {
        spacecore = nixpkgs.lib.nixosSystem {
          inherit system;

          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = [
              agenix.overlays.default
              unstable-overlay
              stable-overlay
              main-overlay
              rust-overlay.overlays.default
            ];
          };

          modules = [
            ./modules

            ./system/common
            ./system/spacecore

            private.nixosModules.system.common
            private.nixosModules.system.spacecore
            {
              nix.registry = {
                self.flake = self;

                nixpkgs = {
                  from = { id = "nixpkgs"; type = "indirect"; };
                  flake = nixpkgs;
                };

                nixpkgs-main = {
                  from = { id = "nixpkgs-main"; type = "indirect"; };
                  flake = nixpkgs-main;
                };

                rust-overlay = {
                  from = { id = "rust-overlay"; type = "indirect"; };
                  flake = rust-overlay;
                };
              };
            }
            agenix.nixosModules.default
            private.nixosModules.agenixSecrets
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.pyrolagus.imports = [
                ./user/pyrolagus
                private.nixosModules.user.pyrolagus.ssh
                private.nixosModules.user.pyrolagus.email
              ];
            }
          ];
        };
      };
    };
}
