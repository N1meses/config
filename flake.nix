
{
  description = "nix-flake: system config and home manager";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    blocklist-hosts = {
      url = "github:StevenBlack/hosts";
      flake = false;
    };

    hyprland = {
      url = "github:hyprwm/Hyprland?submodules=true";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs"; 
    };

    quickshell = {
      url = "github:quickshell-mirror/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{nixpkgs, home-manager,  hyprland, quickshell, noctalia, niri, nixvim, nix-index-database, ...}:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          niri.overlays.niri
        ];
      };

    in {
      nixosConfigurations.nimeses = nixpkgs.lib.nixosSystem{
        inherit system pkgs;

        modules = [

          ./configuration.nix
          home-manager.nixosModules.home-manager

          {
            environment.systemPackages = [
              home-manager.packages.${system}.home-manager
            ];
            
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.nimeses = {
              imports =  [
                niri.homeModules.niri
                nixvim.homeModules.nixvim
                nix-index-database.homeModules.nix-index
                {
                  programs.nix-index-database.comma.enable = true;
                  programs.command-not-found.enable = false;
                }
                ./home/nimeses 
              ];
            };
            home-manager.extraSpecialArgs = { inherit quickshell inputs; };
          }

        ];
        specialArgs = {inherit quickshell inputs;};
      };

      homeConfigurations."nimeses" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
            niri.homeModules.niri
            nixvim.homeModules.nixvim
             nix-index-database.homeModules.nix-index
            {
              programs.nix-index-database.comma.enable = true;
              programs.command-not-found.enable = false;
            }
            ./home/nimeses 
          ];
        extraSpecialArgs = {inherit quickshell inputs;};
      };

      devShells.${system} = {

        python = import ./home/nimeses/devshells/python {
            inherit pkgs;
          };

        java = import ./home/nimeses/devshells/java {
            inherit pkgs;
          };

        stock-analysis = import ./home/nimeses/devshells/stock_analysis {
            inherit pkgs;
          };

        chat = import ./home/nimeses/devshells/chat{
          inherit pkgs;
        };

        qml = import ./home/nimeses/devshells/qml{
          inherit pkgs;
        };
        
        django = import ./home/nimeses/devshells/django{
          inherit pkgs;
        };
      };
  };
}
