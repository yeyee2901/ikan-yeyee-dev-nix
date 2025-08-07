{
  description = "Ikan Yeyee dev";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }:
    let
      system = "x86_64-darwin";
      macPkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations."ikan-yeyee-mac" = home-manager.lib.homeManagerConfiguration {
        inherit macPkgs;
        modules = [
          ./home.nix
        ];
      };

      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          go
          tmux
          neovim
          lazygit
          fzf
          zsh
          nodejs
        ];
      };
    };
}
