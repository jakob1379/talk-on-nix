# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
  };
  

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable blutooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  # Enbale OpenGL
  hardware.opengl = {
    enable = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_DK.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "da_DK.UTF-8";
    LC_IDENTIFICATION = "da_DK.UTF-8";
    LC_MEASUREMENT = "da_DK.UTF-8";
    LC_MONETARY = "da_DK.UTF-8";
    LC_NAME = "da_DK.UTF-8";
    LC_NUMERIC = "da_DK.UTF-8";
    LC_PAPER = "da_DK.UTF-8";
    LC_TELEPHONE = "da_DK.UTF-8";
    LC_TIME = "da_DK.UTF-8";
  };

  # add nix flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable docker
  virtualisation.docker.enable = true;

  # Enable VirtualBox
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true; # virt-manager requires dconf to remember settings

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = true;
      plasma5.enable = true;
    };
    videoDrivers = [ "displayLink" "modesetting" ];
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

    # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jga = {
    isNormalUser = true;
    description = "Jakob Guldberg Aaes";
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" "audio" ];
    packages = with pkgs; [
      rclone
      emacs
      firefox
    ];
  };

  services.xserver.displayManager = {
    autoLogin = {
      enable = true;
      user = "jga";
    };
  };

  # enable fwupd: a simple daemon allowing you to update some devices' firmware, including UEFI for several machines.
  services.fwupd.enable = true;

  # Configure console keymap
  console.keyMap = "dk-latin1";
  services.xserver = {
    xkb.layout = "dk";
    xkb.variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipe wire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    # alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true;

    wireplumber.enable = true;
  };

  # Enable user defined systemd services

  # setup dropbox systemd
  systemd.user.services.dropbox = {
    description = "Dropbox user service for graphical sessions";
    wantedBy = [ "graphical-session.target" ];
    restartIfChanged = true;
    enable = true;
    serviceConfig = {
      ExecStart = "${pkgs.dropbox}/bin/dropbox";
      Type = "simple";
      Environment = "DISPLAY XAUTHORITY";
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    home-manager
  ];

  # enabler fingerprint
  # services.fprintd.enable = true;

  # We want to login with yubikeys
  ## Enable hardware support
  security.pam = {
    u2f = {
      enable = true;
      cue = true;
      control = "requisite";
    };
    yubico = {
      enable = true;
      debug = false;
      mode = "challenge-response";
      id = [ "22313001" "22313027" ];
    };
    ## Enable for programs: security.pam.services.<program>.u2fAuth = true;
    services = {
      kde = {
        rules = {
          auth = {
            u2f = {
              enable = true;
            };
          };
        };
        u2fAuth = true;
        yubicoAuth = false;
      };
      sudo = {
        u2fAuth = true;
        yubicoAuth = false;
        rules = {
          auth = {
            u2f = {
              enable = true;
            };

          };
        };
      };
    };
  };

  # Lock computer when yubikey is connected
  # services.udev.extraRules = ''
  #     ACTION=="remove",\
  #      ENV{ID_BUS}=="usb",\
  #      ENV{ID_MODEL_ID}=="0407",\
  #      ENV{ID_VENDOR_ID}=="1050",\
  #      ENV{ID_VENDOR}=="Yubico",\
  #      RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
  # '';

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    #  enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # some needs special allowance for FHS
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    ruff
  ];

  # Start ssh agent
  programs.ssh.startAgent = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;
  services.fail2ban.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
