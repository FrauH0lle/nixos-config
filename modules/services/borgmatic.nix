{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.borgmatic;
in {
  options.modules.services.borgmatic = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      borgmatic
    ];
    systemd.packages = with pkgs; [
      borgmatic
    ];
  };
}
