{ lib, pkgs, ... }:

# from https://nixos.wiki/wiki/Emacs#Darwin_.28macOS.29

pkgs.emacs30-pgtk.overrideAttrs (old: {
  patches = (old.patches or [ ]) ++ [
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
})
