{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShellNoCC {
  packages = with pkgs; [
    git
    git-lfs
    godot
    godotPackages.export-template
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
}
