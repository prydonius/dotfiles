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
      # Pinned: later commits require bun 1.3.14 which is not yet in nixpkgs (latest unstable has 1.3.13).
      url = "github:anomalyco/opencode/f97e115ee284e7f1291be868cd9d058f4ddaf4a2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, jj-github, opencode, ... }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # The opencode flake pins node_modules hashes for a specific bun version.
      # Bun's bun-install output can differ slightly across patch versions, so
      # we re-pin the hashes here for the bun shipped with our nixpkgs revision.
      # Run with --print-build-logs and update if a future nixpkgs/bun bump
      # changes them again.
      opencodeNodeModulesHashes = {
        "x86_64-linux"   = "sha256-NhXGqdMenkVc6ux7KZCdVR1OWa2hzKKpCSE+NgNOlgQ=";
        "aarch64-linux"  = null;
        "aarch64-darwin" = null;
        "x86_64-darwin"  = null;
      };

      mkOpencodePkg = pkgs: system:
        let
          src = opencode;
          # Reconstruct the package using the flake's own nix expressions but
          # with an overridden node_modules hash.
          rev = src.shortRev or "dirty";
          node_modules = pkgs.callPackage "${src}/nix/node_modules.nix" {
            inherit rev;
            hash = opencodeNodeModulesHashes.${system};
          };
        in
          pkgs.callPackage "${src}/nix/opencode.nix" { inherit node_modules; };

      # Helper to create a home configuration for a given system and username
      mkHomeConfig = system: username:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfreePredicate = pkg:
              builtins.elem (nixpkgs.lib.getName pkg) [
                "claude-code"
              ];
          };
          # The devvm's `developer` user gets opencode/claude-code installed via
          # other means, so skip building them here. Other users get the pinned
          # anomalyco fork, with the node_modules hash re-pinned to whatever the
          # current bun version produces.
          opencode-pkg =
            if username == "developer" then null
            else if opencodeNodeModulesHashes.${system} != null
            then mkOpencodePkg pkgs system
            else opencode.packages.${system}.default;
        in home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix ];
          extraSpecialArgs = {
            inherit system username opencode-pkg;
            jj-github-pkg = jj-github.packages.${system}.default;
          };
        };
    in
    {
      homeConfigurations = {
        # NOTE: Use system-specific configs below (e.g., adnan@aarch64-darwin)
        # There is no default "adnan" because flakes can't auto-detect the current system
        
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
