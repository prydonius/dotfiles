{
  description = "Home Manager configuration for adnan";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      
      # Helper to create a home configuration for a given system
      mkHomeConfig = system: home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [ ./home.nix ];
        extraSpecialArgs = {
          inherit system;
        };
      };
    in
    {
      homeConfigurations = {
        # Default configuration - auto-detect system when possible
        "adnan" = mkHomeConfig "x86_64-linux";
        
        # System-specific configurations
        "adnan@x86_64-linux" = mkHomeConfig "x86_64-linux";
        "adnan@aarch64-linux" = mkHomeConfig "aarch64-linux";
        "adnan@aarch64-darwin" = mkHomeConfig "aarch64-darwin";
        "adnan@x86_64-darwin" = mkHomeConfig "x86_64-darwin";
      };

      # Convenience: allow `nix develop` to drop into a shell with home-manager
      devShells = forAllSystems (system: {
        default = nixpkgs.legacyPackages.${system}.mkShell {
          packages = [ home-manager.packages.${system}.default ];
        };
      });
    };
}
