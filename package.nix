{
  lib,
  stdenvNoCC,
  fetchzip,
  steamDisplayName ? "GE-Proton-RTSP",
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "proton-ge-rtsp-bin";
  version = "GE-Proton10-33-rtsp23-1";

  src = fetchzip {
    url = "https://github.com/SpookySkeletons/proton-ge-rtsp/releases/download/${finalAttrs.version}/${finalAttrs.version}.tar.gz";
    hash = "sha256-gb/d28Lmz4r5Cetp7ct2eQtQZIAcMDxY4F3XCtLk3BY=";
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
