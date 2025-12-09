{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.system.virtualisation;
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

  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = cfg.qemuPackage;
        runAsRoot = true;
        swtpm.enable = cfg.TPM.enable;
      };
    };

    users.users.${config.my.system.host.userName}.extraGroups = ["libvirtd" "kvm"];

    programs.virt-manager.enable = cfg.virtManager.enable;

    environment.systemPackages = with pkgs;
      []
      ++ lib.optional cfg.virtManager.enable virt-manager;
  };
}
