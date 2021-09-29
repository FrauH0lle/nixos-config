{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.media.graphics;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.media.graphics = {
    enable         = mkBoolOpt false;
    tools.enable   = mkBoolOpt true;
    raster.enable  = mkBoolOpt true;
    inkscape.enable  = mkBoolOpt true;
    sprites.enable = mkBoolOpt true;
    models.enable  = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs;
      (if cfg.tools.enable then [
        font-manager
        # For image manipulation from the shell
        imagemagick
      ] else []) ++

      (if cfg.inkscape.enable then [
        unstable.inkscape
      ] else []) ++
  };
}
