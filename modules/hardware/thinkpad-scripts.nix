{ options, config, lib, pkgs, ... }:


with lib;
with lib.my;
let cfg = config.modules.hardware.thinkpad-scripts;
in {
  options.modules.hardware.thinkpad-scripts = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    
    environment.systemPackages = with pkgs; [
      my.thinkpad-scripts
    ];
    # udev
    services.udev.packages = with pkgs; [
      my.thinkpad-scripts
    ];
    # acpid
    services.acpid = {
      enable = true;
      handlers = {
        thinkpad-dock-acpi-hook-1-off = {
          event = "ibm/hotkey LEN0068:00 00000080 00004011";
          action = "/run/current-system/sw/bin/thinkpad-dock-hook off --via-hook acpi1_off";
        };
        thinkpad-dock-acpi-hook-1-on = {
          event = "ibm/hotkey LEN0068:00 00000080 00004010";
          action = "/run/current-system/sw/bin/thinkpad-dock-hook on --via-hook acpi1_on";
        };
        thinkpad-dock-acpi-hook-2 = {
          event = "ibm/hotkey LEN0068:00 00000080 00006030";
          action = "/run/current-system/sw/bin/thinkpad-dock-hook --via-hook acpi2";
        };
        thinkpad-mutemic-acpi-hook = {
          event = "ibm/hotkey HKEY 00000080 0000101b";
          action = "/run/current-system/sw/bin/thinkpad-mutemic";
        };
        thinkpad-rotate-acpi-hook-1-normal = {
          event = "ibm/hotkey HKEY 00000080 0000500a";
          action = "/run/current-system/sw/bin/thinkpad-rotate-hook normal --via-hook acpi1_normal";
        };
        thinkpad-rotate-acpi-hook-1-rotated = {
          event = "ibm/hotkey HKEY 00000080 00005009";
          action = "/run/current-system/sw/bin/thinkpad-rotate-hook --via-hook acpi1_rotated";
        };
        thinkpad-rotate-acpi-hook-2-normal = {
          event = "video/tabletmode TBLT 0000008A 00000000.*";
          action = "/run/current-system/sw/bin/thinkpad-rotate-hook normal --via-hook acpi2_normal";
        };
        thinkpad-rotate-acpi-hook-2-rotated = {
          event = "video/tabletmode TBLT 0000008A 00000001.*";
          action = "/run/current-system/sw/bin/thinkpad-rotate-hook --via-hook acpi2_rotated";
        };
      };
    };
    # Wacom for pen input
    services.xserver.wacom.enable = true;
  };
}
