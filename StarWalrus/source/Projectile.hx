package;

import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame;
import flixel.FlxSprite;

class Projectile extends FlxSprite
{
	private var speed:Float = 2000;
	public function new() 
	{
		super();
		
		var textureAtlasFrames = FlxAtlasFrames.fromTexturePackerJson("assets/images/ingameSprites.png", "assets/data/ingameSprites.json");
		frames = textureAtlasFrames;
		animation.frameName = "projectile.png";
		velocity.x = speed;
	}
	
}
