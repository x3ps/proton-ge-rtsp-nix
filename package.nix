{
  lib,
  stdenvNoCC,
  fetchzip,
  steamDisplayName ? "GE-Proton-RTSP",
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "proton-ge-rtsp-bin";
  version = "GE-Proton10-33-rtsp22-4";

  src =
    let
      # Release tag differs from asset name when upstream does rebuild spins (e.g. -4 suffix).
      tag = "GE-Proton10-33-rtsp22";
    in
    fetchzip {
      url = "https://github.com/SpookySkeletons/proton-ge-rtsp/releases/download/${tag}/${finalAttrs.version}.tar.gz";
      hash = "sha256-YmdO4XaEFbq1lWWorZMqFKVQb+bMxDDH/dpwKaq+Qjg=";
    };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  outputs = [
    "out"
    "steamcompattool"
  ];

  installPhase = ''
    runHook preInstall

    echo "${finalAttrs.pname} should not be installed into environments. Please use programs.steam.extraCompatPackages instead." > $out

    mkdir $steamcompattool
    ln -s $src/* $steamcompattool
    rm $steamcompattool/compatibilitytool.vdf
    cp $src/compatibilitytool.vdf $steamcompattool

    runHook postInstall
  '';

  preFixup = ''
    substituteInPlace "$steamcompattool/compatibilitytool.vdf" \
      --replace-fail "${finalAttrs.version}" "${steamDisplayName}"
  '';

  meta = {
    description = "Proton-GE fork with RTSP streaming support (for use in programs.steam.extraCompatPackages only)";
    homepage = "https://github.com/SpookySkeletons/proton-ge-rtsp";
    license = lib.licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
