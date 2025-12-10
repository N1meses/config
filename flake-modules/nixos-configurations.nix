{
  inputs,
  withSystem,
  config,
  lib,
  ...
}: {
  flake.nixosConfigurations = let
    mkNixosSystem = hostName: system:
      withSystem system ({pkgs, ...}:
        inputs.nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          modules = [
            ../hosts/${hostName}/default.nix
            inputs.home-manager.nixosModules.home-manager

            {
              environment.systemPackages = [
                inputs.home-manager.packages.${system}.home-manager
              ];

              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${hostName} = {
                imports = [
                  inputs.niri.homeModules.niri
                  inputs.nixvim.homeModules.nixvim
                  inputs.nix-index-database.homeModules.nix-index
                  {
                    programs.nix-index-database.comma.enable = true;
                    programs.command-not-found.enable = false;
                  }
                  ../hosts/${hostName}/${hostName}.nix
                ];
              };
              home-manager.extraSpecialArgs = {inherit (inputs) quickshell; inherit inputs;};
            }
          ];
          specialArgs = {inherit (inputs) quickshell; inherit inputs;};
        });
  in
    lib.mapAttrs (name: host:
      mkNixosSystem host.hostName host.system)
    config.flake.hosts;
}
