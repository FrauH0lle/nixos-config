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
        desktopManager.pantheon = {
          enable = true;
          extraWingpanelIndicators = with pkgs; [
            my.wingpanel-indicator-ayatana
          ];
        };
      };
      pantheon.contractor.enable = true;
      pantheon.apps.enable = true;
    };
    programs.pantheon-tweaks.enable = true;

    # Enable flatpak for AppCenter
    services.flatpak.enable = true;
    xdg.portal.enable = true;
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    # URLs
    # flatpak remote-add --if-not-exists appcenter https://flatpak.elementary.io/repo.flatpakrepo
    # flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

    # Enable hibernation option
    environment.etc."polkit-1/localauthority/50-local.d/com.ubuntu.enable-hibernate.pkla" = {
      text = ''
      [Re-enable hibernate by default]
      Identity=unix-user:*
      Action=org.freedesktop.upower.hibernate
      ResultActive=yes

      [Re-enable hibernate by default for login1]
      Identity=unix-user:*
      Action=org.freedesktop.login1.hibernate
      ResultActive=yes

      [Re-enable hibernate for multiple users by default in logind]
      Identity=unix-user:*
      Action=org.freedesktop.login1.hibernate-multiple-sessions
      ResultActive=yes
      '';
    };

    environment.systemPackages = with pkgs; [
      gnome.dconf-editor
      # AppCenter
      pantheon.appcenter
      pantheon.elementary-files
      # For a better Qt application inclusion
      qt5ct
      libsForQt5.qtstyleplugins
      my.ayatana-indicator-application
    ];

    # Try really hard to get QT to respect my GTK theme.
    env.QT_QPA_PLATFORMTHEME = "qt5ct";
  };
}
