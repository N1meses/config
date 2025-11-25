{pkgs}:
pkgs.mkShell {
  name = "chat with GPT";

  packages = with pkgs;[
      python313Full
      uv
    ];

  shellHook = 
    ''
      if [ -f ~/.openai-key ]; then
        export OPENAI_API_KEY="$(cat ~/.openai-key)"
        echo "OpenAI API key loaded"
      else
        echo "Warning: ~/.openai-key not found"
      fi
      echo "Lets do it!"
    '';
}