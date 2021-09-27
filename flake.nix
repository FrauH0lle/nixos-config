{
  description = "NixOS system configuration.";

  # Package sources:
  inputs = {
    # NixOS
    # Primary source
    nixpkgs.url = "nixpkgs/nixos-unstable";
    # More bleeding edge
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";
    # Really on the edge
    nixpkgs-master.url = "nixpkgs/master";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Extras
    nixos-hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = inputs@{
    self
    , nixpkgs
    , nixpkgs-unstable
    , nixpkgs-master
    , ...
  }: let
    inherit (lib.my) mapModules mapModulesRec mapHosts;

    system = "x86_64-linux";

    mkPkgs = pkgs: extraOverlays: import pkgs {
      inherit system;
      # Unfree packages
      config.allowUnfree = true;
      overlays = extraOverlays ++ (lib.attrValues self.overlays);
    };
    pkgs  = mkPkgs nixpkgs [ self.overlay ];
    pkgs' = mkPkgs nixpkgs-unstable [];

    lib = nixpkgs.lib.extend
      (self: super: { my = import ./lib { inherit pkgs inputs; lib = self; }; });
  in {
    lib = lib.my;

    overlay =
      final: prev: {
        unstable = pkgs';
        my = self.packages."${system}";
      };

    overlays =
      mapModules ./overlays import;

    packages."${system}" =
      mapModules ./packages (p: pkgs.callPackage p {});

    nixosModules =
      { dotfiles = import ./.; } // mapModulesRec ./modules import;

    nixosConfigurations =
      mapHosts ./hosts {};

    devShell."${system}" =
      import ./shell.nix { inherit pkgs; };
  };
}
