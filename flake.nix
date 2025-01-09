{
  description = "Andrew's Homelab Flake: WIP";

  outputs = {
    self,
    nixpkgs,
    sops-nix,
    ...
  } @ inputs: {
    nixosConfigurations = {
      # dev machine; currently WNDWKR02 SFF
      sparrow = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/sparrow/default.nix
        ];
      };

      # framework
      eternia = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/eternia/default.nix
          sops-nix.nixosModules.sops
        ];
      };
    };
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    sops-nix.url = "github:Mic92/sops-nix";

    #home-manager.url = "github:nix-community/home-manager/release-24.05";
    #home-manager.inputs.nixpkgs.follows = "nixpkgs";
    #nix-hardware.url = "github:NixOS/nixos-hardware/master";
  };
}
