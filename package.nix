{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "ixui";
  version = "26.11.8-alpha";

  src = fetchFromGitHub {
    owner = "xlmnxp";
    repo = "ixui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3B19Y8yYXHd6DPBnO2jV4XA7r1pM3R1q8rBo4d1lZpw=";
  };

  npmDepsHash = "sha256-ImAbFtwARs8V1/kaDFjM0yM42vkt0l90b+Wr722OQjE=";

  postPatch = ''
    # No .git directory in the source tree, so bake the tagged commit into the
    # build info instead of letting git rev-parse fail at build time.
    substituteInPlace vite.config.ts \
      --replace-fail "git rev-parse --short HEAD" "echo 7b16a48"
  '';

  installPhase = ''
    runHook preInstall

    # incusd reads INCUS_UI as a directory of static files served under /ui/.
    mkdir -p $out
    cp -r dist/. $out/

    runHook postInstall
  '';

  meta = {
    description = "Incus web UI with a Proxmox soul and an ESXi skeleton";
    homepage = "https://github.com/xlmnxp/ixui";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
  };
})
