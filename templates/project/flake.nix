{
  description = "A Nix-managed Unity project flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    godot-shell.url = "github:richen604/godot-shell";
  };

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
    in
    {
      devShells."x86_64-linux".default = pkgs.mkShell {
        packages = with pkgs; [
          git
          git-lfs
          godot
          godotPackages.export-template
          godot-shell.packages.${pkgs.system}.godotenv
        ];

        shellHook = ''
          if [ -f project.godot ]; then
            git init -b main
            git lfs install
            git add .gitattributes && git commit -m "chore: init git lfs"
            touch project.godot
            git commit -am "chore: init godot-shell project"

            echo "🎉 godot-shell template initialized"
            echo "to start godot, run:"
            echo "godot ./project.godot --thread-model safe" 
          fi
        '';
      };
    };
}
