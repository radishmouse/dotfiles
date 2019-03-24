
{ pkgs, ... }:

let

  hosts = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/StevenBlack/hosts/b59510383e681a6489be01ad016da28bdfec5e60/hosts";
    sha256 = "16w5gykzb1kzwf6cvbrh4gddd8izx7gfkm7hqqvkarpwvnag051d";
  };

in

{
  networking.extraHosts = builtins.readFile hosts;
}
