{
  description = "My awesome NixOS config uwu.";
  
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";
    #nixpkgs-master.url = "github:NixOS/nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
  };
  
  outputs = inputs@{self, nixpkgs, home-manager, agenix, ...}:
  let
    system = "x86_64-linux";
    #mkUser = username: {
    #  home-manager.users."${username}" = (import ./home-manager/common.nix) // (import ./home-manager/users/"${username}");
    #};
  in {
    nixosConfigurations = {
      spacecore = nixpkgs.lib.nixosSystem {
        inherit system;

        pkgs = import nixpkgs {
          inherit system;
	        config.allowUnfree = true;
	        overlays = [ agenix.overlay ];
      	};

        modules = [
          ./system/common/nix.nix
          ./system/spacecore/boot.nix
          ./system/spacecore/hardware-configuration.nix
          ./system/spacecore/configuration.nix
          ./system/spacecore/networking.nix
          ./system/spacecore/gaming.nix
          ./private/system/spacecore/users.nix

          {
            nix.registry.nixpkgs.flake = nixpkgs;
          }
	        agenix.nixosModule
          {
            age.secrets.wireless.file = ./private/secrets/wireless.age;
          }
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.pyrolagus = import ./user/pyrolagus/home.nix;
          }
        ];
      };
    };
  };
}
