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
    binDir="$out/bin"
    mv "$binDir/src" "$binDir/Ikemen_GO_Linux"

    cp -r data external font "$binDir/"
  '';

  meta = {
    description = "Ikemen GO is an open source fighting game engine that supports resources from the M.U.G.E.N engine.";
    homepage = "https://github.com/ikemen-engine/Ikemen-GO";
    license = lib.licenses.mit;
  };
})