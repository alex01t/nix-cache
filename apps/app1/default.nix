with import <nixpkgs> {};stdenv.mkDerivation rec {
    name = "app1";    env = buildEnv { inherit name; paths = buildInputs; };
    builder = builtins.toFile "builder.sh" ''
        source $stdenv/setup
        ln -s $env $out
    '';
    buildInputs = [
        (writeShellScriptBin "app1" ''
            echo "Hello World! app11+xxx"
        '')
    ];
}
