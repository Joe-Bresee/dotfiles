{
    description = "Joe's Darwin system flake";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
        nix-darwin.url = "github:LnL7/nix-darwin";
        nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = inputs@{ self, nixpkgs, nix-darwin, ... }:
    let
        configuration = { pkgs, ... }:
        let
            threat-dragon = pkgs.stdenv.mkDerivation rec {
                pname = "threat-dragon";
                version = "2.6.2";

                __noChroot = true;

                src = pkgs.fetchurl {
                    url = "https://github.com/OWASP/threat-dragon/releases/download/v${version}/Threat-Dragon-ng-${version}-arm64.dmg";
                    sha256 = "sha256-Q8LYVkdBvxHk6Mx7dAACOoCFqvWDLH6cQ4tdZE1zLQs=";
                };

                unpackPhase = ''
                    mkdir -p mnt
                    /usr/bin/hdiutil attach -nobrowse -mountpoint mnt "$src"
                    cp -r mnt/*.app .
                    /usr/bin/hdiutil detach mnt
                '';

                installPhase = ''
                    mkdir -p $out/Applications
                    cp -r *.app "$out/Applications/"
                '';
            };
        in
        {
            nixpkgs.config.allowUnfree = true;
            fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

            environment.systemPackages = [
		pkgs.utm
		pkgs.neovim
		pkgs.nodejs_22
                pkgs.opencode
                pkgs.oxipng
                pkgs.bwbasic
                pkgs.ffmpeg
                pkgs.git
                pkgs.yt-dlp
                pkgs.btop
                pkgs.lazygit
                pkgs.stow
                pkgs.eza
                pkgs.starship
                pkgs.fzf
                pkgs.zoxide
                pkgs.vscode
                pkgs.fastfetch
                pkgs.python312
                pkgs.python312Packages.pip
                pkgs.nicotine-plus
                pkgs.gh-dash
                pkgs.k9s
                pkgs.taskwarrior3
                pkgs.taskwarrior-tui
                pkgs.discordo
                pkgs.neomutt
                pkgs.yazi
                pkgs.kew
                pkgs.isync
                pkgs.msmtp
                pkgs.pass
                pkgs.w3m
                pkgs.chafa
                pkgs.f3
                pkgs.nmap
                pkgs.platformio-core
                pkgs.moon-buggy

                threat-dragon
            ];

            system.activationScripts.applications.text = ''
                mkdir -p "/Applications/Nix Apps"
                rm -f "/Applications/Nix Apps/Threat Dragon.app"
                ln -sf "${threat-dragon}/Applications/Threat Dragon.app" "/Applications/Nix Apps/Threat Dragon.app"
            '';

            programs.zsh.enable = true;
            security.pam.services.sudo_local.touchIdAuth = true;

            nix.enable = false;
            system.stateVersion = 5;
            system.primaryUser = "jkbresee";
            nixpkgs.hostPlatform = "aarch64-darwin";
            system.configurationRevision = self.rev or self.dirtyRev or null;

            homebrew = {
                enable = true;
                onActivation = {
                    autoUpdate = true;
                    upgrade = true;
                    cleanup = "zap";
                };
                taps = [
                    "anthonymaley/musictui"
                ];
                brews = [
                    "anthonymaley/musictui/musictui"
                ];
                casks = [
		    "drawio"
                    "brave-browser"
                    "obsidian"
                    "nikitabobko/tap/aerospace"
                    "ghostty"
                    "raycast"
                    "jordanbaird-ice"
                    "aldente"
                    "orbstack"
                    "github"
                    "calibre"
                    "discord"
                    "raspberry-pi-imager"
                    "garmin-express"
		    "orcaslicer"
                ];
            };
        };
    in
    {
        darwinConfigurations."Joes-MacBook-Pro" = nix-darwin.lib.darwinSystem {
            system = "aarch64-darwin";
            modules = [ configuration ];
        };
    };
}
