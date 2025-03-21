{pkgs, config, ...}: let
  # TODO: global notify script
  pamPath = config.sops.secrets."pushover/pam".path;
  userIdPath = config.sops.secrets."pushover/userid".path;

  smartdNotify = pkgs.writeShellScript "smart-notify.sh" ''
    pamToken=$(cat ${pamPath})
    user_id=$(cat ${userIdPath})

    curl -s \
      --form-string "token=$pamToken" \
      --form-string "user=$user_id" \
      --form-string "priority=1" \
      --form-string "title=SMART err ($SMARTD_FAILTYPE) detected" \
      --form-string "message=The following warning/error was logged by the smartd daemon: $SMARTD_MESSAGE. Device info: $SMARTD_DEVICEINFO" \
      https://api.pushover.net/1/messages.json
    '';
in {
  services.smartd = {
    enable = true;
    defaults.monitored = "-a -o on -s (S/../.././02|L/../../7/04)";
    extraOptions = [
      "-w ${smartdNotify.outPath}"
    ];
  };
}

# see: https://github.com/turlando/antigone/blob/6ef2cb728ffc2fca96d1eda15601e49d589e0be4/config/alerting.nix#L45
