package;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class MuzzleFlash extends FlxGroup
{	
	private var flash:FlxSprite;
	private var flashXOffset:Float = 330;
	private var flashYOffset:Float = 90;
	
	private var rings:FlxSprite;
	private var ringsXOffset:Float = 340;
	private var ringsYOffset:Float = 80;

	public function new() 
	{
		super();
		
		var textureAtlasFrames = FlxAtlasFrames.fromTexturePackerJson("assets/images/ingameSprites.png", "assets/data/ingameSprites.json");
		
		flash = new FlxSprite();
		flash.frames = textureAtlasFrames;
		flash.animation.frameName = "muzzleFlash.png";
		add(flash);
		flash.visible = false;
		
		rings = new FlxSprite();
		rings.frames = textureAtlasFrames;
		rings.animation.frameName = "muzzleRings.png";
		add(rings);
		rings.visible = false;
	}

	public function playFlash(x:Float, y:Float):Void {
		flash.setPosition(x + flashXOffset, y + flashYOffset);
		rings.setPosition(x + ringsXOffset, y + ringsYOffset);
		
		flash.scale.y = 0;
		flash.scale.x = 0;
		
		flash.alpha = 1;
		flash.visible = true;
		FlxTween.tween(flash.scale, { x:1,y:1 }, 0.1, { ease: FlxEase.quadIn, onComplete: showRings} );
	}

	private function showRings(tween:FlxTween):Void {
		flash.alpha = 0;
		flash.visible = false;
		
		rings.scale.y = 0;
		rings.scale.x = 0;
		
		rings.alpha = 1;
		rings.visible = true;

		FlxTween.tween(rings.scale, { x:1.5, y:1.5 }, 0.15, { ease: FlxEase.quadIn} );
		FlxTween.tween(rings, { alpha:0 }, 0.3, { ease: FlxEase.quadIn} );
	}
}
