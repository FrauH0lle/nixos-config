{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.bash;
    configDir = config.dotfiles.configDir;
in {
  options.modules.shell.bash = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    programs.bash = {
      enable = true;
      enableCompletion = true;
    };

    user.packages = with pkgs; [
      nix-bash-completions
    ];
  };
}
