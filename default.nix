{ inputs, config, lib, pkgs, ... }:

with lib;
with lib.my;
{
  imports =
    # home-manager
    [ inputs.home-manager.nixosModules.home-manager ]
    # Personal modules
    ++ (mapModulesRec' (toString ./modules) import);

  # Common config for all nixos machines; and to ensure the flake operates
  # soundly
  environment.variables.DOTFILES = config.dotfiles.dir;
  environment.variables.DOTFILES_BIN = config.dotfiles.binDir;

  # Configure nix and nixpkgs
  environment.variables.NIXPKGS_ALLOW_UNFREE = "1";
  nix =
    let filteredInputs = filterAttrs (n: _: n != "self") inputs;
        nixPathInputs  = mapAttrsToList (n: v: "${n}=${v}") filteredInputs;
        registryInputs = mapAttrs (_: v: { flake = v; }) filteredInputs;
    in {
      package = pkgs.nixFlakes;
      extraOptions = "experimental-features = nix-command flakes";
      nixPath = nixPathInputs ++ [
        "nixpkgs-overlays=${config.dotfiles.dir}/overlays"
        "dotfiles=${config.dotfiles.dir}"
      ];
      binaryCaches = [
        "https://nix-community.cachix.org"
      ];
      binaryCachePublicKeys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      registry = registryInputs // { dotfiles.flake = inputs.self; };
      autoOptimiseStore = true;
    };
  system.configurationRevision = with inputs; mkIf (self ? rev) self.rev;

  # Necessities...
  environment.systemPackages = with pkgs; [
    cached-nix-shell
    git
    gnumake
    nano
    sshfs
    unzip
    vim
    wget
    zstd

    # Support for more filesystems
    btrfs-progs
    dosfstools
    exfat
    f2fs-tools
    jfsutils
    mtools
    nilfs-utils
    ntfs3g
    reiserfsprogs
    udftools
    xfsprogs
  ];
}
