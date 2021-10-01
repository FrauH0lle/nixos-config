{ lib, stdenv, fetchFromGitHub, pkgs
, pkg-config, systemd, autoreconfHook
, glib, dbus-glib, json-glib
, gtk3, libayatana-indicator-gtk3, libdbusmenu-gtk3, libayatana-appindicator-gtk3 }:

stdenv.mkDerivation rec {
  pname = "ayatana-indicator-application";
  version = "0.8.0";

  name = "${pname}-gtk3-${version}";

  src = fetchFromGitHub {
    owner = "AyatanaIndicators";
    repo = "ayatana-indicator-application";
    rev = version;
    sha256 = "cuPTGZABBpqtwxkJOKigOw0oJnLACwghW+7A84VJbR8=";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];

  buildInputs = [
    glib dbus-glib json-glib systemd
    gtk3
    libayatana-indicator-gtk3 libdbusmenu-gtk3 libayatana-appindicator-gtk3
  ];

  postPatch = ''
    substituteInPlace data/Makefile.am \
      --replace "/etc/xdg/autostart" "$out/etc/xdg/autostart"
    substituteInPlace data/ayatana-indicator-application.desktop.in \
      --replace "OnlyShowIn=Unity;MATE;XFCE;Budgie;" "OnlyShowIn=Unity;MATE;XFCE;Budgie;Pantheon;"
  '';

  configureFlags = [
    "CFLAGS=-Wno-error"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

  installFlags = [
    "sysconfdir=\${out}/etc"
    "localstatedir=\${TMPDIR}"
  ];

  PKG_CONFIG_SYSTEMD_SYSTEMDUSERUNITDIR = "$(out)/lib/systemd/user";
  PKG_CONFIG_AYATANA_INDICATOR3_0_4_INDICATORDIR = "$(out)/lib/indicators3/7/";

  # Upstart is not used in NixOS
  postFixup = ''
    rm -rf $out/share/indicator-application/upstart
    rm -rf $out/share/upstart
  '';

  meta = with lib; {
    description = "Indicator to take menus from applications and place them in the panel";
    homepage = "https://github.com/AyatanaIndicators/ayatana-indicator-application";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
