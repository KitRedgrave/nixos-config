{ lib, pkgs, inputs, ... }:

# from https://nixos.wiki/wiki/Emacs#Darwin_.28macOS.29
let
  macosPatches = [
    # Fix OS window role
    (pkgs.fetchpatch {
      url =
        "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-28/fix-window-role.patch";
      sha256 = "+z/KfsBm1lvZTZNiMbxzXQGRTjkCFO4QPlEK35upjsE=";
    })
    # Enable rounded window with no decoration
    (pkgs.fetchpatch {
      url =
        "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-30/round-undecorated-frame.patch";
      sha256 = "uYIxNTyfbprx5mCqMNFVrBcLeo+8e21qmBE3lpcnd+4=";
    })
    # Make Emacs aware of OS-level light/dark mode
    (pkgs.fetchpatch {
      url =
        "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-30/system-appearance.patch";
      sha256 = "3QLq91AQ6E921/W9nfDjdOUWR8YVsqBAT/W9c1woqAw=";
    })
  ];
  # this convolution is a temp workaround for https://github.com/NixOS/nixpkgs/issues/395169
  pkgs' = pkgs.extend (final: prev: {
    ld64 = prev.ld64.overrideAttrs (old: {
      patches = old.patches or [ ] ++ [ ./dedupe-rpath-entries.patch ];
    });
  });
  patchedEmacs = pkgs'.emacs30.overrideAttrs
    (old: { patches = (old.patches or [ ]) ++ macosPatches; });
in patchedEmacs.override { withNativeCompilation = true; }
