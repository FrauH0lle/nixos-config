{ lib, stdenv , pkgs, fetchFromGitHub}:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-ayatana";
  version = "2.0.7.1";

  src = fetchFromGitHub {
    owner = "Lafydev";
    repo = pname;
    rev = "1112a797296e023fc112bba058cbc22f3ded6dbc";
    sha256 = "zgEGBmrUlrCQimxBu+n1FZfuM6LxogAW8++b6Ifk4vg=";
  };

  patches = [ ./install.patch ];

  nativeBuildInputs = with pkgs; [
    libxml2
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = with pkgs; [
    pantheon.granite
    (libindicator-gtk3.overrideAttrs (oldAttrs: rec {
      versionMajor = "16.10";
      versioMinor = "1";
      src = fetchbzr {
        url = "https://code.launchpad.net/~indicator-applet-developers/libindicator/trunk.16.10";
        rev = "539";
        sha256 = "axnmiDchVTXvi8XVKIYsjxQuPuXR4Y242dupEbUcK9U=";
      };
      postPatch = "";
      preConfigure = ''
        ./autogen.sh
        substituteInPlace configure \
        --replace 'LIBINDICATOR_LIBS+="$LIBM"' 'LIBINDICATOR_LIBS+=" $LIBM"'
        for f in {build-aux/ltmain.sh,configure,m4/libtool.m4}; do
            substituteInPlace $f\
        --replace /usr/bin/file ${file}/bin/file
        done
        '';
    }))
    (indicator-application-gtk3.overrideAttrs (oldAttrs: rec {
      postPatch = ''
      ${oldAttrs.postPatch}
      substituteInPlace data/indicator-application.desktop.in \
      --replace "OnlyShowIn=Unity;GNOME;" "OnlyShowIn=Unity;GNOME;Pantheon;"
      '';
    }))
    pantheon.wingpanel
  ];

  meta = with lib; {
    description = "Wingpanel Ayatana-Compatibility Indicator";
    homepage = "https://github.com/Lafydev/wingpanel-indicator-ayatana";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
