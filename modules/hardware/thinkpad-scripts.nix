{ options, config, lib, pkgs, ... }:


with lib;
with lib.my;
let cfg = config.modules.hardware.thinkpadScripts;
in {
  options.modules.hardware.thinkpadScripts = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    
    environment.systemPackages = with pkgs; [
      my.thinkpad-scripts
    ];
    # acpid
    services.acpid.enable = true;
    # Wacom for pen input
    services.xserver.wacom.enable = true;
  };
}
