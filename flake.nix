{
  description = "Proton-GE with RTSP streaming patches (binary package)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.${system} = {
        proton-ge-rtsp-bin = pkgs.callPackage ./package.nix { };
        default = self.packages.${system}.proton-ge-rtsp-bin;
      };

      overlays.default = final: _prev: {
        proton-ge-rtsp-bin = final.callPackage ./package.nix { };
      };

      checks.${system} = {
        proton-ge-rtsp-bin = self.packages.${system}.proton-ge-rtsp-bin;
      };

      formatter.${system} = pkgs.nixfmt;
    };
}
