{ config, lib, pkgs, ... }:
{
  options.modules.tailscale.enable = lib.mkEnableOption ''
    Enable tailscale config
  '';

  options.modules.tailscale.authkey = lib.mkOption { type = lib.types.str; };
  options.modules.tailscale.exitnode = lib.mkOption { type = lib.types.bool; default = false; };

  config = lib.mkIf config.modules.nfsmount.enable {
    # make the tailscale command usable to users
    environment.systemPackages = [ pkgs.tailscale ];

    # enable the tailscale service
    services.tailscale = {
      enable = true;
      openFirewall = true;
    };

    # create a oneshot job to authenticate to Tailscale
    systemd.services.tailscale-autoconnect = {
      description = "Automatic connection to Tailscale";

      # make sure tailscale is running before trying to connect to tailscale
      after = [ "network-pre.target" "tailscale.service" ];
      wants = [ "network-pre.target" "tailscale.service" ];
      wantedBy = [ "multi-user.target" ];

      # set this service as a oneshot job
      serviceConfig.Type = "oneshot";

      # have the job run this shell script
      script = with pkgs; ''
        # wait for tailscaled to settle
        sleep 2

        # check if we are already authenticated to tailscale
        status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
        if [ $status = "Running" ]; then # if so, then do nothing
          exit 0
        fi

        # otherwise authenticate with tailscale
        ${tailscale}/bin/tailscale up -authkey ${config.modules.tailscale.authkey} ${if config.modules.tailscale.exitnode then "--advertise-exit-node" else ""}
      '';
    };


  };
}


