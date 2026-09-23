# UVtools for NixOS

The official [UVtools](https://github.com/sn4k3/UVtools) Linux x64 AppImage,
wrapped for NixOS with its desktop entry and icon.

```sh
nix-build -E 'with import <nixpkgs> {}; callPackage ./package.nix {}'
./result/bin/uvtools
./result/bin/uvtools --cmd --core-version
```

Update with `./update.sh`, or pin a release with `./update.sh 7.0.0`.
GitHub Actions checks daily at 09:00 Moscow time and commits updates only
after a successful Nix build.

In UVtools settings, disable **Check for updates on startup** and update through
Nix instead. UVtools 7 has no environment switch for its built-in update checker.

Home Manager (channels):

```nix
let
  uvtoolsSrc = builtins.fetchTarball "https://github.com/farwydi/uvtools-nix/archive/refs/heads/main.tar.gz";
  uvtools = pkgs.callPackage "${uvtoolsSrc}/package.nix" { };
in {
  home.packages = [ uvtools ];
}
```
