package;

import flixel.util.FlxTimer;
import flixel.FlxSprite;

import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.graphics.frames.FlxAtlasFrames;

import flixel.math.FlxPoint;

class Enemy extends FlxSprite
{
	private var movementTween:FlxTween;
	
	private var spawnTimer:FlxTimer;
	
	private var movementSpeed:Float;
	private var movementPattern:Dynamic;
	private var movementPoints:Array<FlxPoint>;

	public function new()
	{
		super();

		var textureAtlasFrames = FlxAtlasFrames.fromTexturePackerJson("assets/images/ingameSprites.png", "assets/data/ingameSprites.json");
		frames = textureAtlasFrames;
		
		animation.addByNames("Idle", ["RocketKitty01.png","RocketKitty02.png"], 8);
		animation.play("Idle");

		spawnTimer = new FlxTimer();
	}

	private function resetSpawn(tween:FlxTween = null):Void {
		this.solid = true;
		this.alpha = 1;
		this.kill();
	}

	public function startPattern(speed:Float,pattern:Dynamic):Void {
		movementSpeed = speed;
		movementPattern = pattern;
		movementPoints = new Array<FlxPoint>();
		
		var point:FlxPoint; 
		for(i in 0...movementPattern.points.length){
			point = new FlxPoint(movementPattern.points[i][0], movementPattern.points[i][1]);
			
			movementPoints.push(point);
		}
		
		
		spawnTimer.start(movementPattern.startDelay, onSpawn);
		setPosition(FlxG.width + width, movementPattern.startY);
	}

	private function onSpawn(timer:FlxTimer):Void {
		movementTween = FlxTween.quadPath(this, movementPoints, movementSpeed, true, { ease: FlxEase.quadIn, onComplete: resetSpawn } );
	}
	
	public function killEnemy():Void {
		this.solid = false;
		movementTween.cancel();
		FlxTween.tween(this, { alpha:0}, 0.15, { ease: FlxEase.quadIn, onComplete: resetSpawn } );
	}
}