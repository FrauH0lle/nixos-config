{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.vm.virtualbox;
in {
  options.modules.desktop.vm.virtualbox = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    virtualisation.virtualbox.host = {
      enable = true;
      # Takes long to build
      # enableExtensionPack = true;
    };

    user.extraGroups = [ "vboxusers" ];
  };
}
