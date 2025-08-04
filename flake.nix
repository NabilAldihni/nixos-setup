{
  description = "My NixOS configuration flake!";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }: 
  let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
  in
  {
    nixosConfigurations = {
      nixos = lib.nixosSystem {
        system = system;
        modules = [ ./configuration.nix ];
      };
    };
  };
}
