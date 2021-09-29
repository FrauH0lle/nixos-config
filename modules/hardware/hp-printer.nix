{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.hardware.hp-printer;
in {
  options.modules.hardware.hp-printer = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.printing = {
      enable = true;
      drivers = with pkgs; [ hplipWithPlugin ];
    };
    hardware.sane = {
      enable = true;
      extraBackends = with pkgs; [ hplipWithPlugin ];
    };
    services.saned.enable = true;
    user.extraGroups = [ "lp" "scanner" ];
  };
}
