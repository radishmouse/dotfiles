{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./stevenblack-hosts.nix
    #./suspend.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/sda1";
      preLVM = true;
    }
  ];

  # optimize for SSD
  fileSystems."/".options = [ "discard" "nodiratime" "noatime" ];

  networking.hostName = "cosima"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.wireless.interfaces = ["wlp3s0"];

  services.ntp.enable = true;
  services.cron.enable = true;

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "US/Eastern";

  #
  # Power and battery
  #
  powerManagement.enable = true;
  services.acpid.enable = true;
  #services.upower.enable = true;

  boot.extraModulePackages = [
    # The acpi_call module is needed by the tlp
    config.boot.kernelPackages.acpi_call
    # config.boot.kernelPackages.tp_smapi

    # and let's make sure we can access our vpn
    config.boot.kernelPackages.wireguard
  ];

  services.tlp = {
    enable = true;
    extraConfig = ''
      START_CHARGE_THRESH_BAT0=75
      STOP_CHARGE_THRESH_BAT0=91
    '';
  };

  boot.resumeDevice = "/dev/disk/by-uuid/9d0d638c-f1f4-4077-902c-221e1871d0b8";
  boot.kernel.sysctl = { "vm.swappiness" = 1; };
  services.logind.lidSwitch = "hybrid-sleep";

  #services.batterySaver = {
  #  enable = true;
  #  hibernateAt = 32;
  #};
  #services.udev.extraRules = ''
  #  SUBSYSTEM=="power_supply", ATTR{status}=="Discharging", ATTR{capacity}=="[0-80]", RUN+="${pkgs.systemd}/bin/systemctl hybrid-sleep"
  #'';

  # This fails because `RANDR Query Version returned error -1`
  # Commenting out for now.
  # powerManagement.resumeCommands = ''
    # echo 'No really, setting backlight to 20 percent'
    # echo `${pkgs.xorg.xrandr}/bin/xrandr --listmonitors`
    # ${pkgs.xorg.xbacklight}/bin/xbacklight -set 20
    # echo 'Should have set backlight to 20 percent'
  # '';

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # power management
    acpitool
    tlp
    linuxPackages.acpi_call

    # network and sysutils
    bind # provides `dig`
    wget
    netcat-openbsd
    nmap
    tcpdump
    iotop
    nethogs
    htop
    zip
    unzip
    unrar
    gnupg
    openssl
    sshfs
    traceroute
    # wireguard
    # wireguard-tools

    # dev
    vim
    emacs
    gitAndTools.gitFull
    ag
    ripgrep
    vagrant
    exercism

    # dev platforms
    platformio

    # X
    dwm
    dmenu
    st
    autocutsel
    xbanish
    slstatus
    tigervnc
    xorg.xbacklight
    xsel
    # slock
    xss-lock
    xorg.xmodmap
    unclutter
    scrot

    # Keybinding obsession
    xbindkeys
    # xbindkeys-config
    xvkbd
    xorg.xev
    xorg.xprop
    xdotool

    # X apps
    firefox-bin
    # Then, put the following in `~/.config/gtk-3.0/settings.ini`:
    # ```
    # Get firefox to use emacs keybindings
    # [Settings]
    # gtk-key-theme-name = Emacs
    # ```
    chromium
    qutebrowser
    zathura

    # AV
    vlc
    alsaTools
    alsaUtils
    # using this intead: hardware.pulseaudio.enable = true;
    # pulseaudioFull

    # misc
    syncthing
    # syncthing-inotify
    pandoc
    cron
    tree
    lsof
    aspell
    aspellDicts.en
    # python27Packages.geeknote
    # ^^ does not login correctly
    borgbackup
    pass
    exfat
  ];

  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.packageOverrides = {
    dwm = pkgs.callPackage /home/radishmouse/src/dwm {};
    slstatus = pkgs.callPackage /home/radishmouse/src/slstatus {};
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  virtualisation.virtualbox.host.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [

    22000 # synthing
    8000 # dev server for local area access
    9000 # dev server for local area access
    3000 # dev server for local node
    8080 # WebGoat
    9090 # WebWolf
  ];
  networking.firewall.allowedUDPPorts = [
    21027 # syncthing
  ];

  services.openssh.enable = true;

  environment.etc."fuse.conf".text = ''
    user_allow_other
  '';

  # enable bonjour/zeroconf
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  hardware.pulseaudio.enable = true;
  # didn't need this one:
  # nixpkgs.config.pulseaudio = true;

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql100;
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all 127.0.0.1/32 trust
      host all all ::1/128 trust
    '';
  };

  services.syncthing = {
    enable = true;
    # systemService = true;
    # leaving as a user service, since my perms are screwy
    # useInotify = true;
    user = "radishmouse";
    dataDir = "/home/radishmouse/.config/syncthing";
    # openDefaultPorts = true;
    # ^^ could have done this instead of in the networking.firewall
    # section.
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "ctrl:nocaps";

    displayManager = {
      slim = {
        enable = true;
      };

      # changed the slock command to the wrapped one, not the source binary.
      # the wrapped version is suid, allowing it to do the OOM thing
      sessionCommands = ''
        ${pkgs.xss-lock}/bin/xss-lock -- /run/wrappers/bin/slock &
        ${pkgs.slstatus}/bin/slstatus &
        ${pkgs.xbindkeys}/bin/xbindkeys&
        ${pkgs.unclutter}/bin/unclutter -noevents&
        ${pkgs.xorg.xmodmap}/bin/xmodmap ~/.Xmodmap&
      '';
    };

    windowManager = {
      default = "dwm";
      dwm.enable = true;
    };

    desktopManager.default = "none";
  };

  fonts = {
    fontconfig = {
      enable = true;
    };

    enableFontDir = true;
    enableGhostscriptFonts = true;

    fonts = with pkgs; [
      corefonts  # Micrsoft free fonts
      inconsolata  # monospaced
      ubuntu_font_family  # Ubuntu fonts
      unifont # some international languages
      dejavu_fonts
      freefont_ttf
      liberation_ttf
    ];
  };


  services.printing.enable = true;
  services.printing.drivers = [ pkgs.gutenprint ];

  programs.slock.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.radishmouse = {
     createHome = true;
     home = "/home/radishmouse";
     isNormalUser = true;
     uid = 1000;
     useDefaultShell = true;
     extraGroups = [ "wheel" ];
   };

  security.sudo.wheelNeedsPassword = false;

  systemd.user.services."autocutsel" = {
    enable = true;
    description = "AutoCutSel";
    wantedBy = [ "default.target" ];
    serviceConfig.Type = "forking";
    serviceConfig.Restart = "always";
    serviceConfig.RestartSec = 2;
    serviceConfig.ExecStartPre = "${pkgs.autocutsel}/bin/autocutsel -fork";
    serviceConfig.ExecStart = "${pkgs.autocutsel}/bin/autocutsel -selection PRIMARY -fork";
  };


  services.udev = {
    extraRules = ''

    # even with upower enabled, no worky...
    #SUBSYSTEM=="power_supply", ATTR{status}=="Discharging", ATTR{capacity}=="[0-80]", RUN+="${pkgs.systemd}/bin/systemctl hybrid-sleep"

# this udev file should be used with udev 188 and newer
ACTION!="add|change", GOTO="u2f_end"

# Yubico YubiKey
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1050", ATTRS{idProduct}=="0113|0114|0115|0116|0120|0200|0402|0403|0406|0407|0410", TAG+="uaccess"

# Happlink (formerly Plug-Up) Security KEY
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="f1d0", TAG+="uaccess"

# Neowave Keydo and Keydo AES
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1e0d", ATTRS{idProduct}=="f1d0|f1ae", TAG+="uaccess"

# HyperSecu HyperFIDO
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="096e|2ccf", ATTRS{idProduct}=="0880", TAG+="uaccess"

# Feitian ePass FIDO, BioPass FIDO2
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="096e", ATTRS{idProduct}=="0850|0852|0853|0854|0856|0858|085a|085b|085d", TAG+="uaccess"

# JaCarta U2F
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="24dc", ATTRS{idProduct}=="0101", TAG+="uaccess"

# U2F Zero
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="8acf", TAG+="uaccess"

# VASCO SeccureClick
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1a44", ATTRS{idProduct}=="00bb", TAG+="uaccess"

# Bluink Key
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="2abe", ATTRS{idProduct}=="1002", TAG+="uaccess"

# Thetis Key
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1ea8", ATTRS{idProduct}=="f025", TAG+="uaccess"

# Nitrokey FIDO U2F
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="20a0", ATTRS{idProduct}=="4287", TAG+="uaccess"

# Google Titan U2F
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="18d1", ATTRS{idProduct}=="5026", TAG+="uaccess"

# Tomu board + chopstx U2F
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="cdab", TAG+="uaccess"

LABEL="u2f_end"
    '';
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?

}
