{
  description = "A Nix-managed Unity project flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
          dvc-with-remotes
          gum
          godot
          godotPackages.export-template
        ];

        shellHook = ''
          # init git - only if not already a git repo with commits
          if [ ! -d .git ] || ([ -d .git ] && ! git rev-parse --verify HEAD >/dev/null 2>&1); then
            # additional safety: don't run during git operations
            if [ -z "$GIT_DIR" ] && [ ! -f .git/rebase-merge/interactive ] && [ ! -f .git/rebase-apply/applying ]; then
              if [ ! -d .git ]; then
                git init .
              fi
              git add flake.nix 2>/dev/null || true
              
              # initialize git hooks only if .git-hooks exists
              if [ -d .git-hooks ]; then
                mkdir -p .git/hooks
                # copy all files (including hidden) from .git-hooks into .git/hooks
                cp -a .git-hooks/. .git/hooks/
                # make any hook files executable; ignore errors if no files
                chmod +x .git/hooks/* 2>/dev/null || true
                # remove the original hooks dir
                rm -rf .git-hooks
              fi

              # append "addons/" to .gitignore if not already present
              if ! grep -qx 'addons/' .gitignore 2>/dev/null; then
                echo "addons/" >> .gitignore
              fi
              
              # only commit if there are staged changes and no existing commits
              if git diff --cached --quiet 2>/dev/null || ! git rev-parse --verify HEAD >/dev/null 2>&1; then
                git add . 2>/dev/null || true
                if ! git diff --cached --quiet 2>/dev/null; then
                  git commit -m "init project from richen604/godot-shell" 2>/dev/null || true
                fi
              fi
            fi
          fi

          # init dvc
          if [ ! -d .dvc ]; then
            dvc init

            dfc config add -d local ./.dvc-storage
          fi
        '';
      };
    };
}
