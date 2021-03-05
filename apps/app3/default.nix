with import <nixpkgs> {};stdenv.mkDerivation rec {
    name = "app3";    env = buildEnv { inherit name; paths = buildInputs; };
    builder = builtins.toFile "builder.sh" ''
        source $stdenv/setup
        ln -s $env $out
    '';
    buildInputs = [
        (writeShellScriptBin "app3" ''
            echo "hello app3!1"
        '')
    ];
}
