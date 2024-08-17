{
  description = "Home Manager configuration of DrRoot";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, home-manager, nixvim, rust-overlay, ... }:
    let
      system = "x86_64-linux";
      #pkgs = nixpkgs.legacyPackages.${system};
       pkgs = import nixpkgs {
        inherit system;
        overlays = [ rust-overlay.overlays.default ];
      };
      homeModules = ./modules;
    in {
      homeConfigurations."DrRoot" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
		./home.nix
		"${homeModules}/git.nix"
		"${homeModules}/nixvim.nix"


    #./modules/hyprland.nix
    #./modules/display-manager.nix
    #./modules/security-services.nix
    #./modules/services.nix
    #./modules/gc.nix
    #./modules/info-fetchers.nix
    #./modules/theme.nix
    #./modules/terminal-utils.nix
    #./modules/environment-variables.nix



		nixvim.homeManagerModules.nixvim

	];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };

    };
}
