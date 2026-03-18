{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
}:

buildDotnetModule rec {
  pname = "godotenv";
  version = "2.16.2";

  src = fetchFromGitHub {
    owner = "chickensoft-games";
    repo = "GodotEnv";
    rev = "v${version}";
    hash = "sha256-6ptL0Tue5H49UXVktxj6tK81qQgeUwPWBZCfijG0mPA=";
  };

  projectFile = "GodotEnv/Chickensoft.GodotEnv.csproj";

  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  postFixup = ''
    ln -s $out/bin/Chickensoft.GodotEnv $out/bin/godotenv
  '';

  meta = with lib; {
    description = "Manage Godot versions and addons from the command line on Windows, macOS, and Linux.";
    homepage = "https://github.com/chickensoft-games/GodotEnv";
    license = licenses.mit;
    maintainers = [ richen604 ];
    platforms = platforms.all;
  };
}
