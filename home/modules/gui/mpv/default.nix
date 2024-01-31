{ pkgs, lib, config, ... }: 
let
    shader = builtins.fetchurl {
        url = "https://gist.githubusercontent.com/agyild/82219c545228d70c5604f865ce0b0ce5/raw/2623d743b9c23f500ba086f05b385dcb1557e15d/FSR.glsl";
        sha256 = "56d8597fc6b7bf6d13f8c3b2bdf1cdc43b06175d51746aab44cf1dca16929b9e";
    };
in
{
  options.modules.gui.mpv.enable = lib.mkEnableOption "Enable personal mpv config";

  config = lib.mkIf config.modules.gui.mpv.enable {
    programs.mpv= {
        enable = true;
        scripts = with pkgs; [
            mpvScripts.uosc
                mpvScripts.vr-reversal
        ];
        config = {
            profile = "high";
            spirv-compiler = "shaderc";
        };
        profiles = {
            high = {
                vo = "gpu-next";
                hwdec = "vaapi";
                scale = "ewa_lanczos";
                video-sync = "display-resample";
                blend-subtitles= "yes";
                interpolation= "yes";
                tscale= "oversample";
                glsl-shader= shader;
            };
        };

    };
  };
}
