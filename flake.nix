{
  description = "Python 3.14 with UV package manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: 
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.python313
            pkgs.uv
            pkgs.python313Packages.python-lsp-server
            pkgs.ruff
            pkgs.black
            pkgs.git
            pkgs.zsh
            pkgs.zsh-syntax-highlighting
            pkgs.zsh-autosuggestions
            pkgs.just
            pkgs.helix
          ];

          shellHook = ''
            echo "Python Shell 🐍"
            export UV_PYTHON=${pkgs.python313}
            export ZSH_SYNTAX_HIGHLIGHTING=${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting
            export ZSH_AUTOSUGGESTIONS=${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions
            if [ ! "$SHELL" = "$(command -v zsh)" ]; then
              export SHELL_NAME="PYTHON-FLAKE"
              export ZDOTDIR="$HOME/devjon/configs/shells/mini.local"
              exec zsh
            fi

            if [ ! -f "./.venv" ]; then
              uv venv
            fi
          
            source .venv/bin/activate
          '';
        };
      });
}
