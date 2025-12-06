{
  config,
  lib,
  pkgs,
  ...
}: let
  msv = config.my.system.virtualisation;
in {
  options.my.system.virtualisation = {
    enable = lib.mkEnableOption "virtualisation support for libvirt and virt-manager";

    virtManager = {
      enable = lib.mkEnableOption "virt-manager gui";
    };

    TPM.enable = lib.mkEnableOption "Enable TPM 2.0 support";

    qemuPackage = lib.mkOption {
      type = lib.types.package;
      default = pkgs.qemu_kvm;
      description = "QEMU package to use";
    };
  };

  config = lib.mkIf msv.enable {
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = msv.qemuPackage;
        runAsRoot = true;
        swtpm.enable = msv.TPM.enable;
      };
    };

    users.users.${config.my.system.host.userName}.extraGroups = ["libvirtd" "kvm"];

    programs.virt-manager.enable = msv.virtManager.enable;

    environment.systemPackages = with pkgs;
      []
      ++ lib.optional msv.virtManager.enable virt-manager
  };
}
