package;

import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.loaders.TexturePackerData;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class ExplosionEffect extends FlxGroup
{
	private var texturePackerData:TexturePackerData;
	
	private var explosionLine:FlxSprite;
	private var lineXOffset:Float = 0;
	private var lineYOffset:Float = 30;
	
	private var explosionBulb:FlxSprite;
	private var bulbXOffset:Float = -20;
	private var bulbYOffset:Float = -120;
	
	
	private var smoke:FlxEmitter;
	private var maxParticles:Int = 5;
	private var smokeDuration:Float = 1;
	
	public var animationComplete:Bool = false;
	
	public function new() 
	{
		super();
		texturePackerData = new TexturePackerData(AssetPaths.ingameSprites__json, AssetPaths.ingameSprites__png);
		
		explosionLine = new FlxSprite();
		explosionLine.loadGraphicFromTexture(texturePackerData, false, "explosionLine.png");
		explosionLine.visible = false;
		
		explosionBulb = new FlxSprite();
		explosionBulb.loadGraphicFromTexture(texturePackerData, false, "explosionBulb.png");
		explosionBulb.visible = false;
		
		smoke = new FlxEmitter(0, 0, maxParticles);
		smoke.setXSpeed(-100, 100);
		smoke.setYSpeed(-100, 100);
		smoke.setScale(0.15, 0.5, 1, 3);
		smoke.setAlpha(0.25, 1, 0, 0);
		smoke.setRotation( -180, 180);
		
		var smokeParticle:FlxParticle;
		for (i in 0...maxParticles) {
			smokeParticle = new FlxParticle();
			smokeParticle.loadGraphicFromTexture(texturePackerData, false, "smoke.png");
			smoke.add(smokeParticle);
		}
		
		
		
		
		add(smoke);
		add(explosionLine);
		add(explosionBulb);
	}
	
	
	public function playExplosion(x:Float, y:Float):Void {
		animationComplete = false;
		
		explosionLine.setPosition(x + lineXOffset, y + lineYOffset);
		explosionBulb.setPosition(x + bulbXOffset, y + bulbYOffset);
		smoke.setPosition(x, y);
		smoke.visible = false;
		
		explosionLine.scale.x = 0;
		explosionLine.alpha = 1;
		explosionLine.visible = true;
		FlxTween.tween(explosionLine.scale, { x:1 }, 0.15, { ease: FlxEase.quadIn,complete: showBulb} );
	}
	
	
	private function showBulb(tween:FlxTween):Void {

		FlxTween.tween(explosionLine, { alpha:0 }, 0.15, { ease: FlxEase.quadIn} );
		
		
		explosionBulb.scale.x = 0;
		explosionBulb.scale.y = 0;
		explosionBulb.alpha = 1;
		explosionBulb.visible = true;
		
		var flipBulb:Float = Math.random();
		if(flipBulb < 0.5){
			FlxTween.tween(explosionBulb.scale, { x:1,y:1 }, 0.15, { ease: FlxEase.quadIn,complete: showSmoke} );
		}else{
			FlxTween.tween(explosionBulb.scale, { x:1,y:-1 }, 0.15, { ease: FlxEase.quadIn,complete: showSmoke} );
		}
		
		
	}
	
	private function showSmoke(tween:FlxTween):Void{
		smoke.visible = true;
		smoke.start(true, smokeDuration);
		
		if(explosionBulb.scale.y > 0){
			FlxTween.tween(explosionBulb.scale, { x:2, y:2 }, 0.15, { ease: FlxEase.quadIn } );
		}else{
			FlxTween.tween(explosionBulb.scale, { x:2, y:-2 }, 0.15, { ease: FlxEase.quadIn } );
		}
		FlxTween.tween(explosionBulb, { alpha:0 }, 0.25, { ease: FlxEase.quadIn } );
		
		var smokeTimeOut:Float = 1;
		FlxTween.num(smokeTimeOut, 0, smokeDuration, { complete:onAnimationComplete } );
	}
	
	private function onAnimationComplete(tween:FlxTween):Void{
		animationComplete = true;
	}
	
	override public function revive():Void{
		super.revive();
		animationComplete = false;
		explosionLine.revive();
		explosionBulb.revive();
		smoke.revive();
	}
}