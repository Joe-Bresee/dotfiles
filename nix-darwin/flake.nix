{
    description = "Joe's Darwin system flake";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
        nix-darwin.url = "github:LnL7/nix-darwin";
        nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = inputs@{ self, nixpkgs, nix-darwin, ... }:
    let
        configuration = { pkgs, ... }: {

            nixpkgs.config.allowUnfree = true;
            fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

            environment.systemPackages = [
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
            ];

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
