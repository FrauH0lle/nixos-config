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
      audio.enable = true;
      bluetooth.enable = true;
      hp-printer.enable = true;
      sensors.enable = true;
    };
    services = {
      borgmatic.enable = true;
    };
    shell = {
      bash.enable = true;
    };
  };

  # Use EurKEY layout in pantheon
  services.xserver.desktopManager.pantheon.extraGSettingsOverrides = ''
  [org.gnome.desktop.input-sources]
  sources=[('xkb','eu')]
  show-all-sources=true
  '';

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.timeout = 1;
  boot.loader.efi.canTouchEfiVariables = true;

  # Latest kernel
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_5_14;

  # CPU
  nix.maxJobs = lib.mkDefault 4;
  hardware.cpu.intel.updateMicrocode = true;

  # GPU
  hardware.opengl.extraPackages = with pkgs; [
    vaapiIntel
    libvdpau-va-gl
    vaapiVdpau
  ];

  # fstrim
  services.fstrim.enable = true;

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

  # services.redshift = {
  #   enable = true;
  #   provider = "geoclue2";
  # };

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
    displaycal
    nextcloud-client
    gnome.simple-scan
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It???s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
