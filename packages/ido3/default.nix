{ lib, stdenv, fetchbzr, pkgs, fetchpatch
, pkg-config, autoreconfHook, autoconf, automake
, intltool
, gtk3, gobject-introspection, gtk-doc, vala
}:

stdenv.mkDerivation rec {
  pname = "ido3-0_1";
  version = "13.10";

  src = fetchbzr {
    url = "https://code.launchpad.net/~indicator-applet-developers/ido/trunk.16.10";
    rev = "198";
    sha256 = "ySpViWECKzTYfQy+OOTlI1NilIr5wO7kzCjNSveQuvw=";
  };

  nativeBuildInputs = with pkgs; [
    pkg-config
    autoreconfHook
    autoconf
    automake
    intltool
    pkgs.gnome.gnome-common
    gtk-doc
    vala
    gobject-introspection ];

  buildInputs = [
    (gtk3.overrideAttrs (oldAttrs: rec {
      patches = [
        oldAttrs.patches
        (fetchpatch {
          url = "https://salsa.debian.org/gnome-team/gtk3/-/raw/ubuntu/master/debian/patches/ubuntu_gtk_custom_menu_items.patch";
          sha256 = "hwwCSDD0M+bY+MJdGVzu7AMz5r1cc7Br59nwPLb5kcg=";
        })
      ];
    }))
  ];

  patchPhase = ''
    substituteInPlace ./src/Makefile.am \
    --replace "-Werror" "-Wno-error"
  '';

  meta = with lib; {
    description = "Widgets and other objects used for indicators.";
    homepage = "https://launchpad.net/ido";
    license = [ licenses.lgpl3Plus licenses.lgpl21Plus ];
    platforms = platforms.linux;
  };
}
