{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    devShells = {
      python = import ../devShells/python {
        inherit pkgs;
      };

      java = import ../devShells/java {
        inherit pkgs;
      };

      stock-analysis = import ../devShells/stock_analysis {
        inherit pkgs;
      };

      chat = import ../devShells/chat {
        inherit pkgs;
      };

      django = import ../devShells/django {
        inherit pkgs;
      };

      mcp-server = import ../devShells/mcp-server {
        inherit pkgs;
      };
    };
  };
}
