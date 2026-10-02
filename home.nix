{ config, pkgs, ... }:

{
	imports = [ ./waybar.nix ];
	programs.waybar-touch.enable = true;
	
	home.username = "wavhart";
	home.homeDirectory = "/home/wavhart";
	programs.git.enable = true;
	home.stateVersion = "26.05";

	xdg.configFile."hypr/hyprland.lua".source = ./hypr/hyprland.lua;
	xdg.configFile."hypr/modules".source = ./hypr/modules;
		

	#PACKAGES
	home.packages = with pkgs;[
	    vscodium
		btop
		bat
		fastfetch
		cmake
		klassy
		waybar
		hyprpaper
		libinput
		thunar
		rofi
		tree
		waypaper
		awww
		mpvpaper
		yetris
		cmatrix
		starship
		github-cli

		#fonts
		nerd-fonts.jetbrains-mono
		nerd-fonts.fira-code
		nerd-fonts.hack
		
	];

	# FONTS
	fonts.fontconfig.enable = true;

#PROGRAM SETTINGS
	# HYPRPAPER
	services.hyprpaper = {
		enable = true;
		settings = {
			ipc = "on";
			splash = false;
			wallpaper = [
			{
				monitor = "eDP-1";
				path = "/home/wavhart/Downloads/wp15843354-rob-gonsalves-wallpapers.png";
				fit_mode = "fill";
				}	
			];
		};
	};
	#zsh
	programs.zsh = {
		enable = true;
		enableCompletion = true;
		autosuggestion.enable = true;
		syntaxHighlighting.enable = true;
		
		#Terminal Aliases
		shellAliases = {
			penisProtocol = "echo 8--D";
			farewell = "systemctl poweroff";
			nrs = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
			gitadd = "cd /ect/nixos && sudo git add .";
			gitcommit = "cd /etc/nixos sudo git commit -m 'iteration'";
			nconf = "sudo micro /etc/nixos/configuration.nix";
			home = "sudo micro /etc/nixos/home.nix";
			hconf = "tree ~/.config/hypr/modules & cd ~/.config/hypr/modules";
			ndir = "cd /etc/nixos";
			kbye = "qdbus org.kde.LogoutPrompt /LogoutPrompt org.kde.LogoutPrompt.promptLogout";
			garbo = "nix-collect-garbage";
			stconf = "sudo micro /etc/nixos/dotfiles/starship.toml";
			kconf = "sudo micro /etc/nixos/dotfiles/kitty.conf";
			dfiles = "cd /etc/nixos/dotfiles";
		};

		history.size = 10000;
		history.ignoreAllDups = true;
		history.path = "$HOME/.zsh_history";
		history.ignorePatterns = ["rm *" "pkill *" "cp *"];

	};

	#kitty
	programs.kitty = {
		enable = true;

		font = {
			name = "JetBrainsMono Nerd Font";
			size = 14;
		};

		settings = {

			force_ltr ="no";
			
			disable_ligature = "never";
			
			cursor_shape = "block";
			cursor_shape_unfocused = "hollow";
			
			cursor_trail = 3;
			#cursor_trail_decay = 0.1, 0.4;
			cursor_trail_start_threshold = 2;
			
			scrollbar_handle_opacity = 0.0;
			
			progress_bar = "top";
			
			window_border_width = "2pt";
			# window_border_radius 2pt
			# #draw_minimal_borders yes
			# draw_window_borders_for_single_window no
			
			window_padding_width = 10;
			
			
			inactive_text_alpga = 0.8;
			
			background_opacity = 0.6;
			
			background_blur = 40;
			active_border_color = "#00ff00";
			
			#hide_window_decorations =  titlebar-only;
		
		} ;
	};

	# Starship
	programs.starship = {
		enable = true;
		enableZshIntegration = true;
		
		settings = builtins.fromTOML (builtins.readFile ./dotfiles/starship.toml);
	};
}
