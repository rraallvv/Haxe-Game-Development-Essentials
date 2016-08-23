package;

import flixel.group.FlxGroup;

import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

import flixel.util.helpers.FlxBounds;
import flixel.util.helpers.FlxPointRangeBounds;
import flixel.util.helpers.FlxRangeBounds;

import audio.SoundManager;

class ExplosionEffect extends FlxGroup
{
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

	public function new() {
		super();

		var textureAtlasFrames = FlxAtlasFrames.fromTexturePackerJson("assets/images/ingameSprites.png", "assets/data/ingameSprites.json");

		explosionLine = new FlxSprite();
		explosionLine.frames = textureAtlasFrames;
		explosionLine.animation.frameName = "explosionLine.png";
		explosionLine.visible = false;

		explosionBulb = new FlxSprite();
		explosionBulb.frames = textureAtlasFrames;
		explosionBulb.animation.frameName = "explosionBulb.png";
		explosionBulb.visible = false;

		smoke = new FlxEmitter(0, 0, maxParticles);
		smoke.velocity.set( -100, 100, -100, 100);
		smoke.scale.set(0.15, 0.5, 1, 3);
		smoke.alpha.set(0.25, 1, 0, 0);
		smoke.angle.set( -180, 180);

		var smokeParticle:FlxParticle;
		for (i in 0...maxParticles) {
			smokeParticle = new FlxParticle();
			smokeParticle.frames = textureAtlasFrames;
			smokeParticle.animation.frameName = "smoke.png";
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
		FlxTween.tween(explosionLine.scale, { x:1 }, 0.15, { ease: FlxEase.quadIn, onComplete: function (tween:FlxTween):Void {
			FlxTween.tween(explosionLine, { alpha:0 }, 0.15, { ease: FlxEase.quadIn} );
			
			explosionBulb.scale.x = 0;
			explosionBulb.scale.y = 0;
			explosionBulb.alpha = 1;
			explosionBulb.visible = true;
			
			var flipBulb:Float = Math.random();
			if(flipBulb < 0.5){
				SoundManager.instance.playExplosion(0);
				FlxTween.tween(explosionBulb.scale, { x:1,y:1 }, 0.15, { ease: FlxEase.quadIn, onComplete: showSmoke} );
			}else{
				SoundManager.instance.playExplosion(1);
				FlxTween.tween(explosionBulb.scale, { x:1,y:-1 }, 0.15, { ease: FlxEase.quadIn, onComplete: showSmoke} );
			}
		}});
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
		FlxTween.num(smokeTimeOut, 0, smokeDuration, { onComplete:function (tween:FlxTween):Void{
			animationComplete = true;
		}});
	}	

	override public function revive():Void{
		super.revive();
		animationComplete = false;
		explosionLine.revive();
		explosionBulb.revive();
		smoke.revive();
	}
	
}
