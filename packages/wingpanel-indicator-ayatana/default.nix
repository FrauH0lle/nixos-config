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

  patches = [
    ./install.patch
    ./0001-use-ayatana.patch
    ./0001-add-vapi.patch
  ];

  nativeBuildInputs = with pkgs; [
    libxml2
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = with pkgs; [
    pantheon.granite
    libayatana-indicator-gtk3
    my.ayatana-indicator-application
    pantheon.wingpanel
  ];

  meta = with lib; {
    description = "Wingpanel Ayatana-Compatibility Indicator";
    homepage = "https://github.com/Lafydev/wingpanel-indicator-ayatana";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
