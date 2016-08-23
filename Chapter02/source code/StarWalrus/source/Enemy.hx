package;

import flixel.util.FlxTimer;
import flixel.FlxSprite;
import AssetPaths;
/**
 * ...
 * @author ...
 */
class Enemy extends FlxSprite
{
	
	private var spawnTimer:FlxTimer;
	private var maxSpawnTime:Float = 14;
	
	private var maxX:Int = 750;
	private var minX:Int = 0;
	private var maxY:Int = 500;
	private var minY:Int = 0;
		
	public function new() 
	{
		super();
		loadGraphic(AssetPaths.enemy01__png);
		
		var randomX:Int = (Math.floor(Math.random() * (maxX - minX + 1)) + minX);
		var randomY:Int = (Math.floor(Math.random() * (maxY - minY + 1)) + minY);
		
		this.setPosition(randomX, randomY);
		
		this.visible = false;
		
		var spawnTime:Float = Math.random() * (maxSpawnTime+ 1);
		
		spawnTimer = new FlxTimer();
		spawnTimer.start(spawnTime, onSpawn);
	
	}
	
	private function onSpawn(timer:FlxTimer):Void {
		this.visible = true;
	}
	
}