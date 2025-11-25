{...}:
{
  networking = {
    hostName = "nixos";

    networkmanager.enable = true;

    firewall ={
      enable = true;
      trustedInterfaces = [ "tailscale0" ];
    };
  };
}