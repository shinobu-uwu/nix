{
  inputs,
  pkgs,
  ...
}: let
  noctalia = pkgs.callPackage (inputs.noctalia + "/nix/package.nix") {};
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
      Restart = "on-failure";
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
