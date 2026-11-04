{
  lib,
  bash,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  pkg-config,
  ffmpeg,
  gtk3,
  libGL,
  libx11,
  libxmp,
  SDL2,
  vulkan-headers,
}:
buildGoModule (finalAttrs: {
  pname = "ikemen-go";
  version = "1.0.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ikemen-engine";
    repo = "Ikemen-GO";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1GbSWQb+vn5R8MJIAQWmSdFHtP1hZ6nn6HGFSVtRkWI=";
  };

  vendorHash = "sha256-m3hDyDHtkeKh+IXlAyeCdxapji57szpsfB5mXjxbmv4=";

  subPackages = [ "src" ];

  env.GOEXPERIMENT = "arenas";

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    ffmpeg
    gtk3
    libGL
    libx11
    libxmp
    SDL2
    vulkan-headers
  ];

  postInstall =
    let
      screenpack = fetchFromGitHub {
        owner = "ikemen-engine";
        repo = "Ikemen-GO-Screenpack";
        rev = "11d6ea7223fc15209664730503412841045f7939";
        hash = "sha256-0RNO+70yBgY6+u/p7lG/1DZo3nq7DbRXwNoPgdPsg6g=";
      };

      controllerDb = fetchFromGitHub {
        owner = "mdqinc";
        repo = "SDL_GameControllerDB";
        rev = "07af1d50187e94c861c9f9f5d8a55b148f11306b";
        hash = "sha256-zvT8MFRGxC8Q3yMONUBIVhpMSbV/dTtiA5UhVBab3bc=";
      };
    in
    ''
      bin="$out/bin"
      share="$out/share"
      resources="$share/ikemen-go"
      licenses="$share/licenses/ikemen-go"

      mv "$bin/src" "$bin/Ikemen_GO_Linux"

      mkdir -p "$resources"
      cp -R data external font "$resources"

      for dir in chars data font sound stages video; do
        cp -R "${screenpack}/$dir" "$resources"
      done

      cp "${controllerDb}/gamecontrollerdb.txt" "$resources/external"

      mkdir -p "$licenses"
      cp LICENCE.txt "$licenses/Ikemen-GO.txt"
      cp "${screenpack}/LICENCE.txt" "$licenses/Ikemen-GO-Screenpack.txt"
      cp "${controllerDb}/LICENSE" "$licenses/SDL_GameControllerDB.txt"

      makeWrapper "${bash}/bin/bash" "$bin/ikemen-go" \
        --add-flags "${./ikemen-go.sh}" \
        --set ENGINE "$bin/Ikemen_GO_Linux" \
        --set RESOURCES "$resources"
    '';

  meta = {
    description = "Open-source fighting game engine compatible with M.U.G.E.N resources";
    homepage = "https://github.com/ikemen-engine/Ikemen-GO";
    license =
      with lib.licenses;
      AND [
        mit
        asl20
        cc-by-30
        cc-by-nc-30
        zlib
      ];
    mainProgram = "ikemen-go";
  };
})
