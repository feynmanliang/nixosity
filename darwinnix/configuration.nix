{ pkgs, username, system, ... }: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [ 
    skhd
  ];

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Enable alternative shell support in nix-darwin.
  # programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  # system.configurationRevision = self.rev or self.dirtyRev or null;

  # https://github.com/nix-community/home-manager/issues/4026
  users.users.admin.home = "/Users/admin";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = system;

  services.yabai = {
    enable = true;
    package = pkgs.yabai;
    enableScriptingAddition = true;
    config = {
      focus_follows_mouse          = "autoraise";
      mouse_follows_focus          = "off";
      window_placement             = "second_child";
      window_opacity               = "off";
      window_opacity_duration      = "0.0";
      window_border                = "on";
      window_border_placement      = "inset";
      window_border_width          = 2;
      window_border_radius         = 3;
      active_window_border_topmost = "off";
      window_topmost               = "on";
      window_shadow                = "float";
      active_window_border_color   = "0xff5c7e81";
      normal_window_border_color   = "0xff505050";
      insert_window_border_color   = "0xffd75f5f";
      active_window_opacity        = "1.0";
      normal_window_opacity        = "1.0";
      split_ratio                  = "0.50";
      auto_balance                 = "on";
      mouse_modifier               = "fn";
      mouse_action1                = "move";
      mouse_action2                = "resize";
      layout                       = "bsp";
      top_padding                  = 36;
      bottom_padding               = 10;
      left_padding                 = 10;
      right_padding                = 10;
      window_gap                   = 10;
    };

    extraConfig = ''
        # rules
        yabai -m rule --add app='System Preferences' manage=off

        # https://ghostty.org/docs/help/macos-tiling-wms#yabai
        yabai -m signal --add app='^Ghostty$' event=window_created action='yabai -m space --layout bsp'
        yabai -m signal --add app='^Ghostty$' event=window_destroyed action='yabai -m space --layout bsp'


        # Any other arbitrary config here
      '';
  };

  services.skhd = {
    enable = true;
    package = pkgs.skhd;
    skhdConfig = ''
      # Focus window
    	ctrl + alt - h : yabai -m window --focus west
    	ctrl + alt - j : yabai -m window --focus south
    	ctrl + alt - k : yabai -m window --focus north
    	ctrl + alt - l : yabai -m window --focus east

    	# Fill space with window
    	ctrl + alt - 0 : yabai -m window --grid 1:1:0:0:1:1

    	# Move window
    	ctrl + alt - e : yabai -m window --display 1; yabai -m display --focus 1
    	ctrl + alt - d : yabai -m window --display 2; yabai -m display --focus 2
    	ctrl + alt - f : yabai -m window --space next; yabai -m space --focus next
    	ctrl + alt - s : yabai -m window --space prev; yabai -m space --focus prev

    	# Close current window
    	ctrl + alt - w : $(yabai -m window $(yabai -m query --windows --window | jq -re ".id") --close)

    	# Rotate tree
    	ctrl + alt - r : yabai -m space --rotate 90

    	# Open application
    	ctrl + alt - return : open -a Ghostty
    	ctrl + alt - b : open -a "Brave Browser"
    	
      ctrl + alt - t : yabai -m window --toggle float;\
        yabai -m window --grid 4:4:1:1:2:2

      ctrl + alt - p : yabai -m window --toggle sticky;\
        yabai -m window --toggle topmost;\
        yabai -m window --toggle pip
    '';
  };
}
