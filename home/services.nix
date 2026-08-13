{
  inputs,
  pkgs,
  ...
}: let
  noctalia = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
  services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
    };
    mpris-proxy.enable = true;
    playerctld.enable = true;
    wl-clip-persist.enable = true;
    plugged = {
      enable = true;
      settings = {
        sounds = {
          enable = true;
          connected = ./assets/connected.oga;
          disconnected = ./assets/disconnected.oga;
        };
        notifications.enable = true;
      };
    };
  };

  systemd.user.services.noctalia = {
    Unit = {
      Description = "Noctalia";
      After = ["graphical-session.target"];
      Wants = ["graphical-session.target"];
      PartOf = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${noctalia}/bin/noctalia";
      Environment = "LC_TIME=en_US.UTF-8";
      Restart = "on-failure";
    };
    Install.WantedBy = ["graphical-session.target"];
  };

}
