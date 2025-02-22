{...}: let
  fqdn = "whoami.zah.rocks";
  router = "whoami";
in {
  virtualisation.oci-containers.containers.whoami = {
    autoStart = true;
    ports = ["8080"];
    image = "docker.io/andrewzah/whoami:1.10.3";
    dependsOn = ["traefik"];
    extraOptions = ["--net=external"];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.authentik.rule" = "Host(`${fqdn}`) && PathPrefix(`/outpost.goauthentik.io/`)";
      "traefik.http.routers.${router}.rule" = "Host(`${fqdn}`)";
      "traefik.http.routers.${router}.middlewares" = "authentik@docker";
    };
  };
}
