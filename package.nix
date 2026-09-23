{ lib, appimageTools, fetchurl }:

let
  sources = builtins.fromJSON (builtins.readFile ./sources.json);
  pname = "uvtools";
  inherit (sources) version;
  src = fetchurl {
    url = "https://github.com/sn4k3/UVtools/releases/download/v${version}/UVtools_linux-x64_v${version}.AppImage";
    inherit (sources) hash;
  };
  contents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;
  extraPkgs = pkgs: [ pkgs.icu pkgs.openssl ];

  extraInstallCommands = ''
    cp -r ${contents}/usr/share $out/
    substituteInPlace $out/share/applications/pt.ptrtech.UVtools.desktop \
      --replace-fail 'Exec="UVtools" %F' "Exec=$out/bin/uvtools %F"
  '';

  meta = {
    description = "MSLA/DLP file analysis, calibration, repair and conversion";
    homepage = "https://github.com/sn4k3/UVtools";
    license = lib.licenses.agpl3Only;
    mainProgram = "uvtools";
    platforms = [ "x86_64-linux" ];
  };
}
