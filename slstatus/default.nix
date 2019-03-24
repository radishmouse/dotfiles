{ stdenv, libX11 }:

stdenv.mkDerivation {
  name = "slstatus";

  src = builtins.filterSource
    (path: type: (toString path) != (toString ./.git)) ./.;

  buildInputs = [ libX11 ];

  prePatch = ''
    substituteInPlace config.mk --replace '/usr/local' $out
  '';

  meta = with stdenv.lib; {
    description = "Stripped down status bar";
    homepage = https://tools.suckless.org/slstatus/;
    license = licenses.mit;
    platforms = platforms.all;
  };
}
