{
  description = "My awesome NixOS config uwu.";
  
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";
    nixpkgs-main.url = "github:NixOS/nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    private.url = "/home/pyrolagus/.config/dotfiles/private.flake";
  };
  
  outputs = inputs@{self, nixpkgs, nixpkgs-unstable, nixpkgs-main, home-manager, agenix, private, ...}:
  let
    system = "x86_64-linux";
    unstable-overlay = final: prev: { unstable = nixpkgs-unstable.legacyPackages."${system}"; };
    main-overlay = final: prev: { main = nixpkgs-main.legacyPackages."${system}"; };
    factorio-overlay = final: prev: { factorio = prev.callPackage ./overlays/factorio { }; };
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
	        overlays = [ agenix.overlay unstable-overlay main-overlay factorio-overlay ];
      	};

        modules = [
          ./system/common/nix.nix
          ./system/spacecore/boot.nix
          ./system/spacecore/hardware-configuration.nix
          ./system/spacecore/configuration.nix
          ./system/spacecore/networking.nix
          ./system/spacecore/gaming.nix
          ./private/system/spacecore/users.nix
          ./private/system/common/wireless_networks.nix
          #private.nixosModules.syscfg.users
          #{
          #  config.syscfg.system = "spacecore";
          #}
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
            home-manager.users.pyrolagus.imports = [
              ./user/pyrolagus/home.nix
              #./private/user/pyrolagus/ssh_hosts.nix
              private.nixosModules.syscfg.pyrolagus
            ];
          }
        ];
      };
    };
  };
}
