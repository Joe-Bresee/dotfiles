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
            mkCraft = { name, version, hash }: pkgs.stdenv.mkDerivation {
                pname = name;
                inherit version;

                __noChroot = true;

                src = pkgs.fetchurl {
                    url = "https://github.com/storytold/${name}/releases/download/v${version}/${name}-${version}-macos-universal.dmg";
                    inherit hash;
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

            craftApps = [
                (mkCraft { name = "photocraft";  version = "0.11.1"; hash = "sha256-kRTL9a2i+fqRtFZtBTJXkky9UOR3sgfqP99xiKTs+9M="; })
                (mkCraft { name = "vectorcraft"; version = "0.13.1"; hash = "sha256-uTLDiSegB/MCGMTtQEpcSKP0FnTW5MVgpmLH/9vbcG8="; })
                (mkCraft { name = "filmcraft";   version = "0.9.0";  hash = "sha256-1lSiO70DlWGmm8VTAgN2kEDKSWHiKCRau4Q3UlJtISQ="; })
                (mkCraft { name = "lightcraft";  version = "0.9.1";  hash = "sha256-Xj/ed1XQ/Q+pERT8WO9RCTqBthd9zZrs4BQrTsEOHFo="; })
                (mkCraft { name = "pdfcraft";    version = "0.9.0";  hash = "sha256-EWc4BFpoRj6xpGXm6u8iZpAqrGmqGhXkocFHLDHYq+k="; })
                (mkCraft { name = "soundcraft";  version = "0.10.0"; hash = "sha256-U7Q012KwpNU541Qo60g4sD/RI+M7+5Pdbd/fsnSJ5Pg="; })
                # effectcraft and designcraft: check their releases page for the
                # version, then add them the same way.
            ];
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
		pkgs.tree
            ] ++ craftApps;

            system.activationScripts.applications.text = ''
                mkdir -p "/Applications/Nix Apps"
                ${pkgs.lib.concatMapStrings (pkg: ''
                    for app in "${pkg}"/Applications/*.app; do
                        ln -sfn "$app" "/Applications/Nix Apps/$(basename "$app")"
                    done
                '') craftApps}
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
		    "Sikarugir-App/sikarugir"
                ];
                brews = [
                    "anthonymaley/musictui/musictui"
                ];
                casks = [
		    "Sikarugir-App/sikarugir/sikarugir"
		    "the-unarchiver"
		    "drawio"
                    "brave-browser"
                    "obsidian"
                    "nikitabobko/tap/aerospace"
                    "ghostty"
                    "raycast"
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
