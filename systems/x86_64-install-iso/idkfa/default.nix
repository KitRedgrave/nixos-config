{ config, lib, pkgs, systems, ... }:

let
  dependencies = [
    systems.idkfa.config.system.build.toplevel
    systems.idkfa.config.system.build.diskoScript
    systems.idkfa.config.system.buiid.diskoScript.drvPath
    systems.idkfa.pkgs.stdenv.drvPath
    systems.idkfa.pkgs.perlPackages.ConfigIniFiles
    systems.idkfa.pkgs.perlPackages.FileSlurp

    (systems.idkfa.pkgs.closureInfo { rootPaths = [ ]; }).drvPath
  ] ++ builtins.map (i: i.outPath) (builtins.attrValues systems.idkfa.inputs);
  closureInfo = pkgs.closureInfo { rootPaths = dependencies; };
in { environment.etc."install-closure".source = "${closureInfo}/store-paths"; }
