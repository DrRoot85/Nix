# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, input,  ... }:

{
  imports =
    [ # Include the results of the hardware scan.
	<nixos-hardware/lenovo/thinkpad/p50>
      ./hardware-configuration.nix
    ];

 nix = {
   package = pkgs.nixFlakes;
   extraOptions = ''
    experimental-features = nix-command flakes
   '';
 };


  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "ThinkPad-P50"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Riyadh";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ar_SA.UTF-8";
    LC_IDENTIFICATION = "ar_SA.UTF-8";
    LC_MEASUREMENT = "ar_SA.UTF-8";
    LC_MONETARY = "ar_SA.UTF-8";
    LC_NAME = "ar_SA.UTF-8";
    LC_NUMERIC = "ar_SA.UTF-8";
    LC_PAPER = "ar_SA.UTF-8";
    LC_TELEPHONE = "ar_SA.UTF-8";
    LC_TIME = "ar_SA.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  nix.gc.automatic = true;
  nix.gc.dates = "weekly";

  # Gnome Exclude Packages
  # environment.gnome.excludePackages = (with pkgs; [
  #   gnome-tour
  # ]) ++ (with pkgs.gnome; [
  #       gnome-terminal
  #       gedit # text editor
  #       epiphany # web browser
  #       geary # email reader
  #       tali # poker game
  #       iagno # go game
  #       hitori # sudoku game
  #       atomix # puzzle game
  # ]);

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us,ara";
    variant = "";
    options = "grp:win_space_toggle";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
#  users.users.mahmoudhb = {
#    isNormalUser = true;
#    description = "Mahmoud Hassan Bashier";
#    extraGroups = [ "networkmanager" "wheel" "audio" "video" "storage" "media" "input" ];
#    packages = with pkgs; [
#    #  thunderbird
#    ];
#  };



  users.users.DrRoot = {
    isNormalUser = true;
    description = "Mahmoud Hassan Bashier";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" "storage" "media" "input" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };


  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config = {
	allowUnfree = true;
	allowBroken = true;
	allowUnsupportedSystem = true;
	allowUnfreePredicate = (pkg: false);
	permittedInsecurePackages = [
		"openssl-1.1.1w"
];
};

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
	neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
	wget
	git
	openssl_1_1
	pkgs.sublime4
	stremio
	zoom-us
	zed-editor
	auto-cpufreq

  ];


  fonts = {                                                  #This is depricated new sytax will
    fonts = with pkgs; [                                   #be enforced in the next realease
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      font-awesome
      source-han-sans
      source-han-sans-japanese
      source-han-serif-japanese
      nerdfonts
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
	      monospace = [ "Meslo LG M Regular Nerd Font Complete Mono" ];
	      serif = [ "Noto Serif" "Source Han Serif" ];
	      sansSerif = [ "Noto Sans" "Source Han Sans" ];
      };
    };
    };


# Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };


  services.xserver.videoDrivers = ["nvidia" "modesetting" ];
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  boot.initrd.availableKernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
  system.nixos.tags = [ "with-nvidia" ];
  system.nixos.label = "nVidia";

  

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.beta;

    # xrandr --listproviders
    # lspci| grep -E 'VGA|3D'

#    optimus_prime = {
#      enable = true;
#      nvidiaBusId = "PCI:1:0:0";
#      intelBusId = "PCI:0:02:0";
#      };

  };


  services.fprintd = {
    enable = true;
    tod.enable = true;
    #tod.driver = pkgs.libfprint-2-tod1-vfs0090;
    tod.driver = pkgs.libfprint-2-tod1-goodix;
    #tod.driver = nixos-06cb-009a-fingerprint-sensor.lib.libfprint-2-tod1-vfs0090-bingch {
  };


    # Enable Services
  services.geoclue2.enable = true;
  programs.direnv.enable = true;
  services.upower.enable = true;
  programs.fish.enable = true;
  programs.dconf.enable = true;
  services.dbus.enable = true;
  services.dbus.packages = with pkgs; [
  	xfce.xfconf
  	gnome2.GConf
  ];
  services.mpd.enable = true;
  programs.thunar.enable = true;
  programs.xfconf.enable = true;
  services.tumbler.enable = true; 
  services.fwupd.enable = true;
  services.auto-cpufreq.enable = true;
  # services.gnome.core-shell.enable = true;
  # services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
