{
  description = "My awesome NixOS config uwu.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";

    private.url = "/home/pyrolagus/.config/dotfiles/private.flake";
    private.inputs.agenix.follows = "agenix";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, agenix, private, ... }:
    let
      system = "x86_64-linux";
      #mkUser = username: {
      #  home-manager.users."${username}" = (import ./home-manager/common.nix) // (import ./home-manager/users/"${username}");
      #};
    in
    {
      nixosConfigurations = {
        spacecore = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };

          pkgs = import nixpkgs rec {
            inherit system;
            config = {
              allowUnfree = true;
            };
            #config.contentAddressedByDefault = true;
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
              };
            }
            agenix.nixosModules.default
            {
              environment.systemPackages = [ agenix.packages.${system}.default ];
            }
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
