{ isNixOSModule ? false }: {
    lib
  , pkgs
  , config
  , ...
}:
with lib; let
  cfg = config.programs.sss_code;
  tomlFormat = pkgs.formats.toml { };
  configDir =
    if pkgs.stdenv.isDarwin then
      "Library/Application Support"
    else
      config.xdg.configHome;
in
{
  options.programs.sss = {
    enable = mkEnableOption "cli to take screenshots";

    copy = mkEnableOption "Copy screenshot to clipboard";
    window-controls = mkEnableOption "Enable window controls";
    shadow = mkEnableOption "Enable shadows";
    shadow-image = mkEnableOption "Enable shadows from captured image";

    # Code Configs
    line-numbers = mkEnableOption "Show Line numbers";
    theme = mkOption {
      type = types.str;
      default = "base16-ocean.dark";
      example = "base16-ocean.dark";
      description = "Theme file to use. May be a path, or an embedded theme. Embedded themes will take precendence.";
    };
    vim-theme = mkOption {
      type = types.str;
      default = "";
      example = "";
      description = "[Not recommended for manual use] Set theme from vim highlights, format: group,bg,fg,style;group,bg,fg,style;";
    };
    extra-syntaxes = mkOption {
      type = types.str;
      default = "";
      example = "~/.config/extra-syntaxes";
      description = "Additional folder to search for .sublime-syntax files in";
    };
    tab-width = mkOption {
      type = types.int;
      default = 4;
      example = "4";
      description = "Tab width";
    };

    # Lib Configs
    fonts = mkOption {
      type = types.str;
      default = "Hack=12.0";
      example = "Hack=12.0;Noto Font Emoji=12.0;";
      description = "The font used to render, format: Font Name=size;Other Font Name=12.0";
    };
    background = mkOption {
      type = types.str;
      default = "#323232";
      description = "Background of image generated. Support: '#RRGGBBAA' 'h;#RRGGBBAA;#RRGGBBAA' 'v;#RRGGBBAA;#RRGGBBAA' or file path";
    };
    radius = mkOption {
      type = types.int;
      default = 15;
      description = "Radius for the screenshot corners";
    };
    author = mkOption {
      type = lib.types.nullOr types.str;
      default = null;
      description = "Author Name of screenshot";
    };
    author-color = mkOption {
      type = types.str;
      default = "#FFFFFF";
      description = "Title bar text color";
    };
    window-title = mkOption {
      type = lib.types.nullOr types.str;
      default = null;
      description = "Window title";
    };
    window-title-background = mkOption {
      type = types.str;
      default = "#4287f5";
      description = "Window title bar background";
    };
    window-title-color = mkOption {
      type = types.str;
      default = "#FFFFFF";
      description = "Title bar text color";
    };
    window-controls-width = mkOption {
      type = types.int;
      default = 120;
      description = "Width of window controls";
    };
    window-controls-height = mkOption {
      type = types.int;
      default = 40;
      description = "Height of window title/controls bar";
    };
    titlebar-padding = mkOption {
      type = types.int;
      default = 10;
      description = "Padding of title on window bar";
    };
    padding-x = mkOption {
      type = types.int;
      default = 80;
      description = "Padding X of inner screenshot";
    };
    padding-y = mkOption {
      type = types.int;
      default = 100;
      description = "Padding Y of inner screenshot";
    };
    shadow-color = mkOption {
      type = types.str;
      default = "#707070";
      description = "Shadow of screenshot. Support: '#RRGGBBAA' 'h;#RRGGBBAA;#RRGGBBAA' 'v;#RRGGBBAA;#RRGGBBAA' or file path";
    };
    shadow-blur = mkOption {
      type = types.int;
      default = 50;
      description = "Blur of shadow";
    };
    save-format = mkOption {
      type = types.oneOf [ "png" "jpeg" "webp" ];
      default = "png";
      description = "The format in which the image will be saved";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    home.file."${configDir}/sss_code/config.toml" = mkIf (cfg != { }) {
      source = tomlFormat.generate "config.toml" cfg;
    };
  };
}
