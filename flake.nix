{
  description = "A configured Neovim flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    neovim-flake = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        nvimFromSrc = inputs.neovim-flake.packages.${system}.neovim;

        customConfig = pkgs.neovimUtils.makeNeovimConfig {
          withPython3 = true;
          extraPython3Packages = p: [ p.debugpy ];
          withNodeJs = true;
          luaRcContent = builtins.readFile ./init.lua;
          plugins = [ pkgs.vimPlugins.lazy-nvim ];
        };

        # Extra packages made available to nvim but not the system
        # system packages take precedence over these
        extraPkgsPath = pkgs.lib.makeBinPath [ ];

        nvimPkg = pkgs.wrapNeovimUnstable nvimFromSrc (
          customConfig // {
            wrapperArgs = customConfig.wrapperArgs
            ++ [ "--suffix" "PATH" ":" extraPkgsPath ]
            ++ [ "--set" "NVIM_APPNAME" "my-nvim-1" ];
          }
        );

        nvimPkg2 = nvimPkg.overrideAttrs (_: prev: {
          postBuild = prev.postBuild + ''
            echo "here"
            ls -lah $out/bin
            ls -lah $out/lib
            exit 1
          '';
        });
      in
      rec {
        packages.nvim = nvimPkg2;
        defaultPackage = packages.nvim;
        apps.nvim = { type = "app"; program = "${defaultPackage}/bin/nvim"; };
        apps.default = apps.nvim;
        overlays.default = final: prev: { neovim = defaultPackage; };
      }
    );
}
