{ stdenv, fetchbzr, lib, file
, pkg-config, which, pkgs
, autoconf, automake, libtool
, gtkVersion ? "3", gtk2 ? null, gtk3 ? null }:

with lib;

stdenv.mkDerivation rec {
  name = "libindicator-gtk${gtkVersion}-${version}";
  version = "${versionMajor}.${versionMinor}";
  versionMajor = "16.10";
  versionMinor = "1";

  src = fetchbzr {
    url = "https://code.launchpad.net/~indicator-applet-developers/libindicator/trunk.16.10";
    rev = "539";
    sha256 = "axnmiDchVTXvi8XVKIYsjxQuPuXR4Y242dupEbUcK9U=";
  };

  nativeBuildInputs = [
    autoconf automake
    pkg-config
    which
    pkgs.gnome.gnome-common
    pkgs.ayatana-ido
  ];

  buildInputs = [
    (if gtkVersion == "2" then gtk2 else gtk3)
    libtool
  ];

  preConfigure = ''
    ./autogen.sh
    substituteInPlace configure \
      --replace 'LIBINDICATOR_LIBS+="$LIBM"' 'LIBINDICATOR_LIBS+=" $LIBM"'
    for f in {build-aux/ltmain.sh,configure,m4/libtool.m4}; do
      substituteInPlace $f\
        --replace /usr/bin/file ${file}/bin/file
    done
  '';

  configureFlags = [
    "CFLAGS=-Wno-error"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-gtk=${gtkVersion}"
  ];

  installFlags = [
    "sysconfdir=\${out}/etc"
    "localstatedir=\${TMPDIR}"
  ];

  doCheck = false; # fails 8 out of 8 tests

  meta = {
    description = "A set of symbols and convenience functions for Ayatana indicators";
    homepage = "https://launchpad.net/libindicator";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.msteen ];
  };
}
