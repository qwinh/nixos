# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  boot.loader.timeout = 0;
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };
  system.stateVersion = "25.05";

  nixpkgs.config.allowUnfree = true;

  nix.settings.auto-optimise-store = true;

  networking = {
    hostName = "q";
    networkmanager = {
      enable = true;
      dns = "none";
    };
    resolvconf.enable = true;
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
    firewall.enable = true;
  };

  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.q = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "input" ];
    initialPassword = "a";
    shell = pkgs.zsh;
  };

  programs = {
    hyprland.enable = true;
    dconf.enable = true;
    zsh.enable = true;
  };

  environment.systemPackages = with pkgs; [
    xwayland

    alacritty
    git
    micro
    wl-clipboard
    vscodium
    tree

    librewolf
    btop
    calibre
    kdePackages.okular #reader
    hypridle
    tmux
    
    libinput

    lsp-plugins #audio
    easyeffects

    grim
    slurp

    rustdesk-flutter
  ];

  environment.sessionVariables = {
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
  };

  services = {
    chrony.enable = true;

    dbus.enable = true;
  
    udev.extraHwdb = ''
      evdev:input:b*
        KEYBOARD_KEY_3a=leftctrl
        KEYBOARD_KEY_1d=capslock
        KEYBOARD_KEY_38=leftmeta
        KEYBOARD_KEY_db=leftalt
    '';
  };

  security = {
  	polkit.enable = true;
  	sudo.wheelNeedsPassword = false;
  	rtkit.enable = true;
  };
  

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      terminus_font
      freefont_ttf
    ];
  
    fontconfig = {
      enable = true;
      antialias = false;
      subpixel.rgba = "none";
  
      defaultFonts = {
        monospace = [ "Terminus" ];
        sansSerif = [ "Terminus" ];
        serif = [ "Terminus" ];
      };
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    config.common.default = "*";
  };

  hardware.graphics.enable = true;

  zramSwap = {
    enable = true;
    memoryPercent = 25; # Use 50% of RAM for zram swap
    algorithm = "zstd"; # Default, efficient compression
    priority = 100; # Higher priority than disk swap (if any)
  };
}
