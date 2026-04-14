# proton-ge-rtsp-nix

Nix flake for [proton-ge-rtsp](https://github.com/SpookySkeletons/proton-ge-rtsp) — a Proton-GE fork with RTSP streaming patches for VRChat video players.

This is a binary repackaging (no compilation). The package follows the same multi-output pattern as [proton-ge-bin](https://github.com/NixOS/nixpkgs/blob/master/pkgs/by-name/pr/proton-ge-bin/package.nix) in nixpkgs.

## Usage

Add the flake input:

```nix
# flake.nix
inputs.proton-ge-rtsp.url = "github:x3ps/proton-ge-rtsp-nix";
```

### Via `packages` (recommended)

```nix
programs.steam = {
  enable = true;
  extraCompatPackages = [
    inputs.proton-ge-rtsp.packages.${pkgs.system}.proton-ge-rtsp-bin
  ];
};
```

### Via overlay

```nix
nixpkgs.overlays = [ inputs.proton-ge-rtsp.overlays.default ];

# then in your config:
programs.steam = {
  enable = true;
  extraCompatPackages = [ pkgs.proton-ge-rtsp-bin ];
};
```

### Custom display name in Steam

By default the tool appears as **GE-Proton-RTSP** in Steam. To override:

```nix
(inputs.proton-ge-rtsp.packages.${pkgs.system}.proton-ge-rtsp-bin.override {
  steamDisplayName = "My RTSP Proton";
}).steamcompattool
```

## Flake outputs

| Output | Description |
|---|---|
| `packages.x86_64-linux.proton-ge-rtsp-bin` | The package |
| `packages.x86_64-linux.default` | Alias for the above |
| `overlays.default` | Nixpkgs overlay adding `proton-ge-rtsp-bin` |
| `checks.x86_64-linux.proton-ge-rtsp-bin` | Build check |
| `formatter.x86_64-linux` | `nixfmt` |

## Updating

When a new upstream release is published, update `version`, `tag` (if it differs from the asset name), and `hash` in `package.nix`:

```bash
# Get the new hash (will fail with the correct hash in the error):
nix build .#proton-ge-rtsp-bin
```

> **Note:** Some releases have a rebuild suffix (e.g. `-4`) where the GitHub tag and asset name differ. In that case `tag` and `version` must be set separately — see the comment in `package.nix`.

## Platform

x86_64-linux only — matches upstream Proton binaries.

## License

This flake: [BSD-3-Clause](LICENSE)

Upstream Proton-GE-RTSP: [BSD-3-Clause](https://github.com/SpookySkeletons/proton-ge-rtsp/blob/master/LICENSE.proton) (top-level; individual components carry their own licenses)
