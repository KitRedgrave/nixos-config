{ self, inputs, ... }:

builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy)
inputs.deploy-rs.lib
