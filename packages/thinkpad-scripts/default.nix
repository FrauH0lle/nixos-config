{ lib, pkgs, python3, fetchFromGitHub, python3Packages }:

with python3.pkgs;
buildPythonApplication rec {
  pname = "thinkpad-scripts";
  version = "4.12.0";

  src = fetchFromGitHub {
    owner = "martin-ueding";
    repo = "thinkpad-scripts";
    rev = "v${version}";
    sha256 = "08adx8r5pwwazbnfahay42l5f203mmvcn2ipz5hg8myqc9jxm2ky";
  };

  buildInputs = [ pkgs.sphinx ];

  propagatedBuildInputs = [
    pkgs.acpid
    pkgs.xorg.xinput
    pkgs.xorg.xrandr
    pkgs.xf86_input_wacom
    python3Packages.setuptools
  ];

  patches = [ ./activation_patch.patch ];

  makeFlags = [ "PREFIX=$(out)" ];

  postPatch = ''
  substituteInPlace tps/hooks.py --replace "/usr/bin/thinkpad" "$out/bin/thinkpad"
  substituteInPlace tps/hooks.py --replace "sudo" "/run/wrappers/bin/sudo"
  '';

  preInstall = ''
  # Hooks
  for f in thinkpad-*; do
      substituteInPlace "$f" --replace "/usr/bin/" "$out/bin/"
  done

  for f in 81-thinkpad-dock.rules; do
      substituteInPlace "$f" --replace "/usr/bin/logger" "${pkgs.logger}/bin/logger"
      substituteInPlace "$f" --replace "/usr/bin/thinkpad-dock-hook" "$out/bin/thinkpad-dock-hook"
  done

  make SHELL=${pkgs.bashInteractive}/bin/bash DESTDIR=$out install
  '';

  meta = {
    description = "Screen rotation, docking and other scripts for ThinkPad® X220 and X230 Tablet";
    homepage = "https://github.com/martin-ueding/thinkpad-scripts";
    license = lib.licenses.gpl2Plus;
    maintainers = [];
  };
}
