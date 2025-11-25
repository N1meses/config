{pkgs, ...}:
{
  programs.virt-manager.enable = true;
  
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;  # <--- Keep this! This is needed for TPM 2.0
    };
  };

  users.users.nimeses.extraGroups = [
    "libvirtd"
    "kvm"
  ];

  environment.systemPackages = with pkgs; [
    qemu_kvm
    virt-manager
  ];

}
