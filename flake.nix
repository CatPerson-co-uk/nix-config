# flake.nix
{
	description = "catperson nixos config";
	inputs = {
		nixos.url = "github:NixOS/nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixos";
		};
	};

	outputs = {self, nixos, nixpkgs, home-manager, ...}: let
	system = "x86_64-linux";
	pkgs = import nixpkgs { inherit system; };
		
	in {
		nixosConfigurations.nixConfig = nixos.lib.nixosSystem {
			inherit system;
			modules = [
				./configuration.nix
				home-manager.nixosModules.home-manager
				{
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true;
					home-manager.backupFileExtension = "backup";
					home-manager.users.catperson = { pkgs, ... }: {
						imports = [ 
							./home.nix 
						];
					};
					services.flatpak.enable = true;
				}
				# Setup Cursor AppImage
				({ pkgs, ... }: {
					systemd.services.setup-cursor = {
						description = "Setup Cursor AppImage";
						wantedBy = ["multi-user.target"];
						after = ["network-online.target"];
						wants = ["network-online.target"];
						serviceConfig = {
							Type = "oneshot";
							RemainAfterExit = true;
							ExecStart = let
								script = pkgs.writeShellScriptBin "setup-cursor" ''
									CURSOR_DIR="/home/catperson/.local/share/cursor"
									CURSOR_BIN="/home/catperson/.local/bin/cursor"
									DESKTOP_FILE="/home/catperson/.local/share/applications/cursor.desktop"
									APPIMAGE_PATH="$CURSOR_DIR/cursor.AppImage"
									
									# Create directories if they don't exist
									mkdir -p "$CURSOR_DIR"
									mkdir -p "/home/catperson/.local/bin"
									mkdir -p "/home/catperson/.local/share/applications"
									
									# Download AppImage only if it doesn't exist
									if [ ! -f "$APPIMAGE_PATH" ]; then
										echo "Downloading Cursor AppImage..."
										${pkgs.curl}/bin/curl -L "https://downloader.cursor.sh/linux/appImage/x64" -o "$APPIMAGE_PATH"
										chmod +x "$APPIMAGE_PATH"
									else
										echo "Cursor AppImage already exists, skipping download."
									fi
									
									# Create launcher script
									echo '#!/usr/bin/env bash' > "$CURSOR_BIN"
									echo "exec ${pkgs.appimage-run}/bin/appimage-run \"$APPIMAGE_PATH\" \"\$@\"" >> "$CURSOR_BIN"
									chmod +x "$CURSOR_BIN"

									# Create desktop entry if it doesn't exist
									if [ ! -f "$DESKTOP_FILE" ]; then
										echo "Creating desktop entry..."
										cat > "$DESKTOP_FILE" << EOF
[Desktop Entry]
Name=Cursor
Comment=An AI-first code editor
Exec=${pkgs.appimage-run}/bin/appimage-run "$APPIMAGE_PATH" %F
Icon=$APPIMAGE_PATH
Terminal=false
Type=Application
Categories=Development;IDE;TextEditor;
MimeType=text/plain;inode/directory;
StartupWMClass=Cursor
EOF
									else
										echo "Desktop entry already exists, skipping creation."
									fi
									
									# Set proper ownership
									chown -R catperson:users "$CURSOR_DIR"
									chown -R catperson:users "/home/catperson/.local/bin"
									chown -R catperson:users "/home/catperson/.local/share/applications"
								'';
							in "${script}/bin/setup-cursor";
						};
					};
				})
			];
			specialArgs = { inherit system; };
		};

		systemd.services.setup-flatpak = {
			description = "Setup Flatpak and install Floorp";
			wantedBy = ["multi-user.target"];
			after = ["network-online.target"];
			wants = ["network-online.target"];
			serviceConfig = {
				Type = "oneshot";
				ExecStart = let
					script = pkgs.writeShellScriptBin "setup-flatpak" ''
						${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
						${pkgs.flatpak}/bin/flatpak install -y flathub one.ablaze.floorp
					'';
				in "${script}/bin/setup-flatpak";
			};
		};
	};
}
