{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.pantheon;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.pantheon = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {

    # Enable the Pantheon Desktop Environment.
    services = {
      xserver = {
        enable = true;
        libinput.enable = true;
        displayManager.lightdm.enable = true;
        displayManager.lightdm.greeters.pantheon.enable = true;
        desktopManager.pantheon.enable = true;
      };
      pantheon.contractor.enable = true;
      pantheon.apps.enable = true;
    };
    programs.pantheon-tweaks.enable = true;

    # Enable flatpak for AppCenter
    services.flatpak.enable = true;
    xdg.portal.enable = true;
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

    environment.systemPackages = with pkgs; [
      gnome.dconf-editor
      # AppCenter
      pantheon.appcenter
      pantheon.elementary-files
      # QPlatformTheme for a better Qt application inclusion in GNOME
      qgnomeplatform
      # SVG-based Qt5 theme engine plus a config tool and extra theme
      libsForQt5.qtstyleplugin-kvantum
    ];
  };
}
