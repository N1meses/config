{
  inputs,
  config,
  lib,
  ...
}: let
  cfg = config.my.user.noctalia;
in {
  imports = [
    inputs.noctalia.homeModules.default
  ];

  options.my.user.noctalia = {
    enable = lib.mkEnableOption "Enable Noctalia shell";

    bar = {
      position = lib.mkOption {
        type = lib.types.enum ["left" "right" "top" "bottom"];
        default = "left";
        description = "where bar is spawned";
      };

      margin = {
        vertical = lib.mkOption {
          type = lib.types.float;
          default = 0.5;
          description = "vertical distance to screen edge";
        };

        horizontal = lib.mkOption {
          type = lib.types.float;
          default = 0.4;
          description = "horizontal distance to screen edge";
        };
      };
    };

    dock = {
      enable = lib.mkEnableOption "Enable noctalia dock";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.noctalia-shell = {
      enable = true;
      settings = {
        appLauncher = {
          backgroundOpacity = 0.69;
          customLaunchPrefix = "";
          customLaunchPrefixEnabled = false;
          enableClipboardHistory = true;
          pinnedExecs = [];
          position = "center";
          sortByMostUsed = true;
          terminalCommand = "ghostty -e";
          useApp2Unit = false;
        };

        audio = {
          cavaFrameRate = 30;
          mprisBlacklist = [];
          preferredPlayer = "";
          visualizerQuality = "high";
          visualizerType = "linear";
          volumeOverdrive = false;
          volumeStep = 2;
        };

        bar = {
          backgroundOpacity = 0.955555;
          density = "default";
          exclusive = true;
          floating = true;
          marginHorizontal = cfg.bar.margin.horizontal;
          marginVertical = cfg.bar.margin.vertical;
          monitors = [];
          outerCorners = false;
          position = cfg.bar.position;
          showCapsule = true;
          widgets = {
            center = [
              {
                hideMode = "hidden";
                id = "MediaMini";
                maxWidth = 120;
                scrollingMode = "hover";
                showAlbumArt = false;
                showVisualizer = true;
                useFixedWidth = true;
                visualizerType = "linear";
              }
            ];
            left = [
              {
                customIconPath = "/home/nimeses/nixconfig/modules/user/icon/nixos.png";
                icon = "NixOS";
                id = "ControlCenter";
                useDistroLogo = false;
              }
              {
                id = "Tray";
              }
              {
                id = "TaskbarGrouped";
              }
            ];
            right = [
              {
                id = "WallpaperSelector";
              }
              {
                id = "SystemMonitor";
                showCpuTemp = true;
                showCpuUsage = true;
                showDiskUsage = false;
                showMemoryAsPercent = true;
                showMemoryUsage = true;
                showNetworkStats = true;
                usePrimaryColor = true;
              }
              {
                displayMode = "alwaysshow";
                id = "Battery";
                warningThreshold = 30;
              }
              {
                displayMode = "onhover";
                id = "Volume";
              }
              {
                displayMode = "onhover";
                id = "Bluetooth";
              }
              {
                displayMode = "onhover";
                id = "WiFi";
              }
              {
                customFont = "";
                formatHorizontal = "HH:mm";
                formatVertical = "HH mm";
                id = "Clock";
                useCustomFont = false;
                usePrimaryColor = true;
              }
              {
                id = "SessionMenu";
              }
            ];
          };
        };

        battery = {
          chargingMode = 0;
        };

        brightness = {
          brightnessStep = 2;
          enableDdcSupport = false;
          enforceMinimum = true;
        };

        colorSchemes = {
          darkMode = true;
          generateTemplatesForPredefined = true;
          manualSunrise = "06:30";
          manualSunset = "18:30";
          matugenSchemeType = "scheme-neutral";
          predefinedScheme = "Noctalia (default)";
          schedulingMode = "off";
          useWallpaperColors = true;
        };

        controlCenter = {
          cards = [
            {
              enabled = true;
              id = "profile-card";
            }
            {
              enabled = true;
              id = "shortcuts-card";
            }
            {
              enabled = true;
              id = "audio-card";
            }
            {
              enabled = false;
              id = "weather-card";
            }
            {
              enabled = true;
              id = "media-sysmon-card";
            }
          ];
          position = "close_to_bar_button";
          shortcuts = {
            left = [
              {
                id = "WiFi";
              }
              {
                id = "Bluetooth";
              }
              {
                id = "PowerProfile";
              }
              {
                id = "Notifications";
              }
            ];
            right = [
              {
                id = "KeepAwake";
              }
              {
                id = "NightLight";
              }
              {
                id = "ScreenRecorder";
              }
              {
                id = "WallpaperSelector";
              }
            ];
          };
        };

        dock = {
          backgroundOpacity = 0.69;
          colorizeIcons = false;
          displayMode = "auto_hide";
          enabled = cfg.dock.enable;
          floatingRatio = 0.5;
          monitors = [];
          onlySameOutput = true;
          pinnedApps = [];
          size = 1;
        };

        general = {
          animationDisabled = false;
          animationSpeed = 1.5;
          avatarImage = "/home/nimeses/nixconfig/modules/user/icon/hunter.jpeg";
          compactLockScreen = false;
          dimDesktop = true;
          enableShadows = false;
          forceBlackScreenCorners = false;
          language = "";
          lockOnSuspend = true;
          radiusRatio = 0.95;
          scaleRatio = 1;
          screenRadiusRatio = 1;
          shadowDirection = "bottom_right";
          shadowOffsetX = 2;
          shadowOffsetY = 3;
          showScreenCorners = false;
        };

        hooks = {
          darkModeChange = "";
          enabled = false;
          wallpaperChange = "";
        };

        location = {
          analogClockInCalendar = false;
          firstDayOfWeek = -1;
          name = "Tokyo";
          showCalendarEvents = true;
          showCalendarWeather = true;
          showWeekNumberInCalendar = false;
          use12hourFormat = false;
          useFahrenheit = false;
          weatherEnabled = false;
        };

        network = {
          wifiEnabled = true;
        };

        nightLight = {
          autoSchedule = true;
          dayTemp = "6500";
          enabled = false;
          forced = false;
          manualSunrise = "06:30";
          manualSunset = "18:30";
          nightTemp = "4000";
        };

        notifications = {
          backgroundOpacity = 0.69;
          criticalUrgencyDuration = 15;
          doNotDisturb = false;
          enabled = true;
          location = "top_right";
          lowUrgencyDuration = 3;
          monitors = [];
          normalUrgencyDuration = 8;
          overlayLayer = true;
          respectExpireTimeout = false;
        };

        osd = {
          autoHideMs = 2000;
          enabled = true;
          location = "top_right";
          monitors = [];
          overlayLayer = true;
        };

        screenRecorder = {
          audioCodec = "opus";
          audioSource = "default_output";
          colorRange = "limited";
          directory = "/home/nimeses/Videos";
          frameRate = 60;
          quality = "very_high";
          showCursor = true;
          videoCodec = "h264";
          videoSource = "portal";
        };

        settingsVersion = 21;
        setupCompleted = true;

        templates = {
          #set to true
          gtk = true;
          qt = true;
          ghostty = true;

          #set to false
          alacritty = false;
          code = false;
          discord = false;
          discord_armcord = false;
          discord_dorion = false;
          discord_equibop = false;
          discord_lightcord = false;
          discord_vesktop = false;
          discord_webcord = false;
          enableUserTemplates = false;
          foot = false;
          fuzzel = false;
          kcolorscheme = false;
          kitty = false;
          pywalfox = false;
          spicetify = false;
          vicinae = false;
          walker = false;
          wezterm = false;
        };

        ui = {
          fontDefault = "IBM Plex";
          fontDefaultScale = 1;
          fontFixed = "IBM Plex Mono";
          fontFixedScale = 1;
          panelsAttachedToBar = true;
          settingsPanelAttachToBar = false;
          tooltipsEnabled = true;
        };

        wallpaper = {
          defaultWallpaper = "/home/nimeses/nixconfig/modules/user/wallpaper/wallhaven_exkqk8.jpg";
          directory = "/home/nimeses/nixconfig/modules/user/wallpaper"; # Added!
          enableMultiMonitorDirectories = false;
          enabled = true;
          fillColor = "#000000";
          fillMode = "crop";
          monitors = [];
          overviewEnabled = false;
          panelPosition = "follow_bar";
          randomEnabled = true;
          randomIntervalSec = 600;
          recursiveSearch = false;
          setWallpaperOnAllMonitors = true;
          transitionDuration = 1500;
          transitionEdgeSmoothness = 0.05;
          transitionType = "random";
        };
      };
    };
  };
}
