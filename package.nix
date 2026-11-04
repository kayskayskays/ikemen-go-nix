{
  lib,
  bash,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  libGL,
  vulkan-headers,
  gtk3,
  libx11,
  libxmp,
  SDL2,
  ffmpeg,
}:
buildGoModule (finalAttrs: {
  pname = "ikemen-go";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "ikemen-engine";
    repo = "Ikemen-GO";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1GbSWQb+vn5R8MJIAQWmSdFHtP1hZ6nn6HGFSVtRkWI=";
  };

  env.GOEXPERIMENT = "arenas";

  subPackages = [ "src" ];

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    libGL
    vulkan-headers
    gtk3
    libx11
    libxmp
    SDL2
    ffmpeg
  ];

  vendorHash = "sha256-m3hDyDHtkeKh+IXlAyeCdxapji57szpsfB5mXjxbmv4=";

  postInstall =
    let
      screenpack = fetchFromGitHub {
        owner = "ikemen-engine";
        repo = "Ikemen-GO-Screenpack";
        rev = "11d6ea7223fc15209664730503412841045f7939";
        hash = "sha256-0RNO+70yBgY6+u/p7lG/1DZo3nq7DbRXwNoPgdPsg6g=";
      };
    in
    ''
      bin="$out/bin"
      share="$out/share"
      resources="$share/ikemen-go"
      licenses="$share/licenses/ikemen-go"

      mv "$bin/src" "$bin/Ikemen_GO_Linux"

      mkdir -p "$resources"
      cp -r data external font "$resources"

      for dir in chars data font sound stages video; do
        cp -r "${screenpack}/$dir" "$resources"
      done

      cp src/resources/defaultMotif.ini "$resources/data/system.base.def"

      mkdir -p "$licenses"
      cp LICENCE.txt "$licenses/Ikemen-GO.txt"
      cp "${screenpack}/LICENCE.txt" "$licenses/Ikemen-GO-Screenpack.txt"

      makeWrapper "${bash}/bin/bash" "$bin/ikemen-go" \
        --add-flags "${./ikemen-go.sh}" \
        --set ENGINE "$bin/Ikemen_GO_Linux"
        --set RESOURCES "$resources"
    '';

  meta = {
    mainProgram = "ikemen-go";
    description = "Open-source fighting game engine compatible with M.U.G.E.N resources";
    homepage = "https://github.com/ikemen-engine/Ikemen-GO";

    license =
      with lib.licenses;
      AND [
        mit
        asl20
        cc-by-30
        cc-by-nc-30
      ];
  };
})
