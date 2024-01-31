final: prev:
{
  godot_4 = prev.godot_4.overrideAttrs (old: {
    src = prev.fetchFromGitHub {
      owner = "godotengine";
      repo = "godot";
      rev = "e709ad4d6407e52dc62f00a471d13eb6c89f2c4c";
      hash = "sha256-8Vwf5KIwUL3hvV6OrGeHaWtTLktcurO5keyk3dh0g78=";
    };
  });
}
