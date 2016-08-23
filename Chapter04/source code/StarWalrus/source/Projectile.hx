package;

import flixel.util.loaders.TexturePackerData;
import flixel.FlxSprite;

class Projectile extends FlxSprite
{
	private var texturePackerData:TexturePackerData;
	private var speed:Float = 2000;
	public function new() 
	{
		super();
		
		texturePackerData = new TexturePackerData(AssetPaths.ingameSprites__json, AssetPaths.ingameSprites__png);
		loadGraphicFromTexture(texturePackerData, false, "projectile.png");
		this.velocity.x = speed;
	}
	
}