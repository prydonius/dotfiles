# DevVM NixOS configuration
#
# This file is automatically deployed by home-manager to /etc/nixos/configuration.nix
# and triggers a nixos-rebuild when changed.
{ pkgs, ... }:

{
  users.users.developer.shell = pkgs.zsh;
}
