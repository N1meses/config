{
  description = "Chat environment with OpenAI client";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        pythonEnv = pkgs.python313.withPackages (ps: with ps; [
          openai
        ]);
      in
      {
        devShells.default = pkgs.mkShell {
          name = "chat with GPT";
          
          packages = with pkgs; [
            pythonEnv
            uv
          ];

          shellHook = ''
            echo "Lets do it!"
            echo "Python environment ready with OpenAI client"
            echo "Usage: python chat.py"
          '';
        };

        packages.default = pkgs.writeShellApplication {
          name = "chat-cli";
          runtimeInputs = [ pythonEnv ];
          text = ''
            cd ${./.}
            python chat.py "$@"
          '';
        };

        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/chat-cli";
        };
      });
}