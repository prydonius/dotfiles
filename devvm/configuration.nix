# DevVM NixOS configuration
#
# This file is automatically deployed by home-manager to /etc/nixos/configuration.nix
# and triggers a nixos-rebuild when changed.
{ pkgs, lib, ... }:

{
  programs.zsh.enable = true;
  environment.interactiveShellInit = lib.mkForce "";

  users.users.adnan = {
    isNormalUser = true;
    shell = pkgs.zsh;
    group = "users";
  };
}
