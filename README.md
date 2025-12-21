This flake was made as an alternative to the package hosted in nixpkgs.

The package in nixpkgs uses pokemmo-installer rather than performing a direct download. My hope is that this maintains version consistency, even if PokeMMO is mostly meant to self-update.

This flake will create mutable directories in .local/share/pokemmo like `themes`, `mods`, `config`, `roms`, etc. while keeping the rest linked as read-only for the core Nix experience. I think this is pretty robust for this kind of application.

Enable this in your flake.nix inputs using `pokemmo.url = "github:/powerofthe69/pokemmo-nix";`.

Enable the overlay using `nixpkgs.overlays = [ pokemmo.overlay ];`.

To install the latest version, use:

`environment.systemPackages = with pkgs; [ pokemmo ];` or `users.users.youruser.packages = with pkgs; [ pokemmo ];`
