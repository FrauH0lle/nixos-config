{ pkgs, config, lib, inputs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x230
    ./hardware-configuration.nix
  ];

  ## Modules
  modules = {
    desktop = {
      pantheon.enable = true;
      browsers = {
        default = "vivaldi";
        vivaldi.enable = true;
      };
    };
    editors = {
      default = "nano";
      emacs.enable = true;
    };
    hardware = {
      thinkpad-scripts.enable = true;
    };
  };
  
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  # Latest kernel
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_5_14;

  # CPU
  nix.maxJobs = lib.mkDefault 4;
  hardware.cpu.intel.updateMicrocode = true;

  # User name
  users.users.roland.description = "Roland Goers";

  # Hostname
  networking.hostName = "x230t";

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # The global useDHCP flag is deprecated, therefore explicitly set to false
  # here. Per-interface useDHCP will be mandatory in the future, so this
  # generated config replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s25.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "de_DE.UTF-8";
  # Console settings
  console = {
    font = "ter-116n";
    packages = with pkgs; [ terminus_font ];
  };
  
  # Configure keymap in X11
  services.xserver.layout = "eu";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Laptop settings
  services.tlp.settings = {
    "START_CHARGE_THRESH_BAT0" = 67;
    "STOP_CHARGE_THRESH_BAT0" = 100;
  };

  # Hibernation
  boot.kernelParams = [ "resume_offset=1895246" ];
  boot.resumeDevice = "/dev/mapper/crypto";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    auto-cpufreq
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
