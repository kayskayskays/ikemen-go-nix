{
  pkgs,
  lib,
  buildGoModule,
  fetchFromGitHub,
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

  subPackages = ["src"];

  nativeBuildInputs = with pkgs; [
    pkg-config
    makeWrapper
  ];

  buildInputs = with pkgs; [
    libGL
    vulkan-headers
    gtk3
    libx11
    libxmp
    SDL2
    ffmpeg
  ];

  vendorHash = "sha256-m3hDyDHtkeKh+IXlAyeCdxapji57szpsfB5mXjxbmv4=";

  postInstall = ''
    bin="$out/bin"
    share="$out/share/ikemen-go"

    mv "$bin/src" "$bin/Ikemen_GO_Linux"
    mkdir -p "$share"

    cp -r data external font "$share"

    makeWrapper "${pkgs.bash}/bin/bash" "$bin/ikemen-go" \
      --add-flags "${./ikemen-go.sh}" \
      --set ENGINE "$bin/Ikemen_GO_Linux"

    makeWrapper "${pkgs.bash}/bin/bash" "$bin/ikemen-go-init" \
      --add-flags "${./ikemen-go-init.sh}" \
      --set RESOURCES "$share" \
      --prefix PATH : "${lib.makeBinPath [ pkgs.coreutils ]}"
  '';

  meta = {
    mainProgram = "ikemen-go";
    description = "Ikemen GO is an open source fighting game engine that supports resources from the M.U.G.E.N engine.";
    homepage = "https://github.com/ikemen-engine/Ikemen-GO";
    license = with lib.licenses; [ mit asl20 ];
  };
})