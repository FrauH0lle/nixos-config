# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" "coretemp" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/67aac200-89a5-4e20-8176-58b9efa14ae6";
      fsType = "btrfs";
      options = [ "subvol=@root" "defaults" "noatime" "ssd" "space_cache" "compress=zstd" "commit=120" ];
    };

  boot.initrd.luks.devices."crypto".device = "/dev/disk/by-uuid/73795f2b-5a94-4779-bd46-d8e5c33bf760";

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/67aac200-89a5-4e20-8176-58b9efa14ae6";
      fsType = "btrfs";
      options = [ "subvol=@home" "defaults" "noatime" "ssd" "space_cache" "compress=zstd" "commit=120" ];
    };

  fileSystems."/tmp" =
    { device = "/dev/disk/by-uuid/67aac200-89a5-4e20-8176-58b9efa14ae6";
      fsType = "btrfs";
      options = [ "subvol=@tmp" "defaults" "noatime" "ssd" "space_cache" "compress=zstd" "commit=120" ];
    };

  fileSystems."/var" =
    { device = "/dev/disk/by-uuid/67aac200-89a5-4e20-8176-58b9efa14ae6";
      fsType = "btrfs";
      options = [ "subvol=@var" "defaults" "noatime" "ssd" "space_cache" "compress=zstd" "commit=120" ];
    };

  fileSystems."/.swap" =
    { device = "/dev/disk/by-uuid/67aac200-89a5-4e20-8176-58b9efa14ae6";
      fsType = "btrfs";
      options = [ "subvol=@swap" "defaults" "noatime" "ssd" "space_cache" "compress=zstd" "commit=120" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/D29C-2796";
      fsType = "vfat";
    };

  swapDevices = [{
    device = "/.swap/swapfile";
    size = 8192;
  }];

}
