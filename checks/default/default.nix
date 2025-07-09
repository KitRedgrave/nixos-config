{ inputs, config, ... }:

builtins.mapAttrs (system: deployLib: deployLib.deployChecks config.deploy)
inputs.deploy-rs.lib
