{ config, lib, ... }:

{
  ## System security tweaks
  # tmpfs = /tmp is mounted in ram. Doing so makes temp file management speedy
  # on ssd systems, and volatile! Because it's wiped on reboot.
  boot.tmpOnTmpfs = lib.mkDefault true;
  # If not using tmpfs, which is naturally purged on reboot, we must clean it
  # /tmp ourselves. /tmp should be volatile storage!
  boot.cleanTmpDir = lib.mkDefault (!config.boot.tmpOnTmpfs);

  ## I/O scheduler
  boot.initrd.kernelModules = [ "bfq" ];
  services.udev.extraRules = ''
  # set scheduler for NVMe
  ACTION=="add|change", KERNEL=="nvme[0-9]n[0-9]", ATTR{queue/scheduler}="none"
  # set scheduler for SSD and eMMC
  ACTION=="add|change", KERNEL=="sd[a-z]|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"
  # set scheduler for rotating disks
  ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
  '';

}
