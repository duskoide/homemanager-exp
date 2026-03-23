{
  description = "Zenbook Home Manager & NVF Flake";

  inputs = {
    # We use the unstable branch to get the absolute latest NVF features
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nvf, nixgl, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      # This name must match your username ("pn")
      homeConfigurations."pn" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Pass the inputs so NVF can be evaluated
        extraSpecialArgs = { inherit inputs; };

        modules = [
          #1. Your existing user configuration
          ./home.nix
          
          # 2. The NVF Home Manager module
          nvf.homeManagerModules.default
        ];
      };
    };
}
