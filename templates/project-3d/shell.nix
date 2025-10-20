{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  packages = with pkgs; [
    git
    dvc-with-remotes
    gum
    godot
  ];

  shellHook = ''
    # init git
    if [ ! -d .git ]; then
      git init . && git add flake.nix
    fi
    if [ ! -d .dvc ]; then
      dvc init
    fi

    # initialize .git-hooks into .git/hooks safely and idempotently
    if [ -d .git-hooks ]; then
      if [ ! -e .git/hooks/pre-commit ]; then
        mkdir -p .git/hooks
        # copy all files (including hidden) from .git-hooks into .git/hooks
        cp -a .git-hooks/. .git/hooks/
        # make any hook files executable; ignore errors if no files
        chmod +x .git/hooks/* 2>/dev/null || true
        # remove the original hooks dir
        rm -rf .git-hooks
        echo "Installed git hooks"
      fi
    fi

    git add . && git commit -m "init project from richen604/godot-shell"
  '';
}
