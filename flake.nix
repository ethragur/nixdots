{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    polybar-pulseaudio-control = {
      url = "github:marioortizmanero/polybar-pulseaudio-control";
      flake = false;
    };
    secrets = {
      url = "git+file:./secrets";
      flake = true;
    };
    nixpak = {
      url = "github:nixpak/nixpak";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpak-pkgs = {
      url = "github:nixpak/pkgs";
      inputs.nixpak.follows = "nixpak";
    };
    nix-flatpak = {
      url = "github:gmodena/nix-flatpak";
    };

  };


  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, stylix, secrets, nix-flatpak, polybar-pulseaudio-control, nixpak, ... }@inputs:
    let inherit (self) outputs;
    in {
      nixosConfigurations = {
        effi-desktop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          system = "x86_64-linux";
          modules = [
            ({ config, pkgs, ... }:
              let
                overlay-unstable = final: prev: {
                  unstable = nixpkgs-unstable.legacyPackages.x86_64-linux;
                };
              in
              {
                nixpkgs.overlays = [ overlay-unstable ];
              })
            home-manager.nixosModules.home-manager
            stylix.nixosModules.stylix
            secrets.nixosModules.secrets
            ./configuration.nix
            ./hosts/effi-desktop/default.nix
            {
              nixpkgs.config.allowUnfree = true;
              home-manager.useUserPackages = true;
              home-manager.useGlobalPkgs = true;
              home-manager.users = builtins.listToAttrs (builtins.map (u: { name = u; value = { imports = [ (import ./home inputs) ]; }; }) secrets.nixosModules.users);
            }
          ];
        };
        effi-envy = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          system = "x86_64-linux";
          modules = [
            ({ config, pkgs, ... }:
              let
                overlay-unstable = final: prev: {
                  unstable = nixpkgs-unstable.legacyPackages.x86_64-linux;
                };
              in
              {
                nixpkgs.overlays = [ overlay-unstable ];
              })
            home-manager.nixosModules.home-manager
            stylix.nixosModules.stylix
            secrets.nixosModules.secrets
            ./configuration.nix
            ./hosts/effi-envy/default.nix
            {
              nixpkgs.config.allowUnfree = true;

              home-manager.useUserPackages = true;
              home-manager.useGlobalPkgs = true;

              home-manager.users = builtins.listToAttrs (builtins.map (u: { name = u; value = { imports = [ (import ./home inputs) ]; }; }) secrets.nixosModules.users);
            }
          ];
        };
      };
    };
}

