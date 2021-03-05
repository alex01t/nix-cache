with import <nixpkgs> {};stdenv.mkDerivation rec {
    name = "app4";    env = buildEnv { inherit name; paths = buildInputs; };
    builder = builtins.toFile "builder.sh" ''
        source $stdenv/setup
        ln -s $env $out
    '';
    buildInputs = [
        (writeShellScriptBin "app4" ''
            echo "hello app4!1"
        '')
    ];
}
