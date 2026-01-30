{
  description = "Home Manager configuration for adnan";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jj-github = {
      url = "github:cbrewster/jj-github";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    opencode = {
      url = "github:anomalyco/opencode";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, jj-github, opencode, ... }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      
      # Helper to create a home configuration for a given system and username
      mkHomeConfig = system: username: home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [ ./home.nix ];
        extraSpecialArgs = {
          inherit system username;
          jj-github-pkg = jj-github.packages.${system}.default;
          opencode-pkg = opencode.packages.${system}.default;
        };
      };
    in
    {
      homeConfigurations = {
        # Default configuration for adnan
        "adnan" = mkHomeConfig "x86_64-linux" "adnan";
        
        # System-specific configurations for adnan
        "adnan@x86_64-linux" = mkHomeConfig "x86_64-linux" "adnan";
        "adnan@aarch64-linux" = mkHomeConfig "aarch64-linux" "adnan";
        "adnan@aarch64-darwin" = mkHomeConfig "aarch64-darwin" "adnan";
        "adnan@x86_64-darwin" = mkHomeConfig "x86_64-darwin" "adnan";
        
        # Configuration for developer user
        "developer" = mkHomeConfig "x86_64-linux" "developer";
        "developer@x86_64-linux" = mkHomeConfig "x86_64-linux" "developer";
        "developer@aarch64-linux" = mkHomeConfig "aarch64-linux" "developer";
      };

      # Convenience: allow `nix develop` to drop into a shell with home-manager
      devShells = forAllSystems (system: {
        default = nixpkgs.legacyPackages.${system}.mkShell {
          packages = [ home-manager.packages.${system}.default ];
        };
      });
    };
}
