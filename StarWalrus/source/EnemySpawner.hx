package;

import flixel.group.FlxGroup.FlxTypedGroup;
import haxe.Json;
import openfl.Assets;
import flixel.util.FlxTimer;
import flixel.FlxG;

class EnemySpawner extends FlxTypedGroup<Enemy>
{
	private var patternData:Dynamic; 
	private var numEnemies:Int = 10;
	private var spawnTimer:FlxTimer;
	private var currentPattern:Int = 0;
	
	public function new() 
	{
		super(numEnemies);
		
		patternData = Json.parse(Assets.getText("assets/data/movementPatterns.json"));
		var enemy:Enemy;
		for (i in 0...numEnemies) {
			enemy = new Enemy();
			add(enemy);
			enemy.kill();
		}
		spawnTimer = new FlxTimer();
		
		spawnEnemies();
	}
	
	private function spawnEnemies(timer:FlxTimer = null):Void {
		/**/
		currentPattern = (Math.floor(Math.random() * ((patternData.patterns.length-1) - 0 + 1)) + 0);

		var enemy:Enemy;
		for(i in 0...patternData.patterns[currentPattern].enemies.length){
			enemy = recycle();
			enemy.startPattern(patternData.patterns[currentPattern].speed, patternData.patterns[currentPattern].enemies[i]);
		}
		spawnTimer.start(patternData.patterns[currentPattern].timeOnScreen, spawnEnemies);	
	}
}
