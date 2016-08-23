package;


import flixel.util.FlxTimer;
import flixel.FlxSprite;
import AssetPaths;


import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.loaders.TexturePackerData;

import flixel.util.FlxPoint;//CH6

class Enemy extends FlxSprite
{
	private var texturePackerData:TexturePackerData;	
	private var movementTween:FlxTween;
	
	private var spawnTimer:FlxTimer;
	
	//CH6
	private var movementSpeed:Float;
	private var movementPattern:Dynamic;
	private var movementPoints:Array<FlxPoint>;
	
	public function new() 
	{
		super();
		texturePackerData = new TexturePackerData(AssetPaths.ingameSprites__json, AssetPaths.ingameSprites__png); 
		loadGraphicFromTexture(texturePackerData);
		var frameNames:Array<String> = new Array<String>();
		frameNames.push("RocketKitty01.png");
		frameNames.push("RocketKitty02.png");
		
		animation.addByNames("Idle", frameNames, 8);
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
		movementTween = FlxTween.quadPath(this, movementPoints, movementSpeed, true, { ease: FlxEase.quadIn, complete: resetSpawn } );
	}
	
	public function killEnemy():Void {
		this.solid = false;
		movementTween.cancel();
		FlxTween.tween(this, { alpha:0}, 0.15, { ease: FlxEase.quadIn,complete: resetSpawn} );
	}
	

	
}