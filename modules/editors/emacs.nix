{ config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.editors.emacs;
    configDir = config.dotfiles.configDir;
in {
  options.modules.editors.emacs = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      ## Emacs itself
      # binutils       # native-comp needs 'as', provided by this
      # emacsPgtkGcc   # 28 + pgtk + native-comp
      emacs27

      ## Dependencies
      git
      (ripgrep.override {withPCRE2 = true;})
      gnutls              # for TLS connectivity

      ## Optional dependencies
      fd                  # faster projectile indexing
      imagemagick         # for image-dired
      (mkIf (config.programs.gnupg.agent.enable)
        pinentry_emacs)   # in-emacs gnupg prompts
      zstd                # for undo-tree compression

      ## Module dependencies
      # :checkers spell
      (aspellWithDicts (ds: with ds; [
        en en-computers en-science de
      ]))
      # :checkers grammar
      languagetool
      # :lang latex & :lang org (latex previews)
      texlive.combined.scheme-medium
    ];

    env.PATH = [ "$HOME/.emacs.d/bin" ];

    # modules.shell.zsh.rcFiles = [ "${configDir}/emacs/aliases.zsh" ];

    fonts.fonts = [ pkgs.emacs-all-the-icons-fonts ];
  };
}
