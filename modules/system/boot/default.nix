{pkgs, ...}:
{
  boot = {

    kernelPackages = pkgs.linuxPackages_latest;
    
    loader = {
      systemd-boot.enable = true;
      systemd-boot.editor = false;
      systemd-boot.configurationLimit = 10;

      efi.canTouchEfiVariables = true;
    };

    supportedFilesystems = [ "ntfs" ];
    
    initrd.systemd.enable = true;

    initrd.verbose = false;

    plymouth.enable = true;
  };
}
  
