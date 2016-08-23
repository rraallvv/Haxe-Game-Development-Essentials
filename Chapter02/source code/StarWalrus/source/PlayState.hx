package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

// Extra Imported classes
import source.ui.LevelEndScreen;
import flixel.plugin.MouseEventManager;
import flixel.FlxObject;
import flixel.util.FlxTimer;
/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	private var background:FlxSprite;
	private var txtScore:FlxText;
	private var txtTime:FlxText;
	
	private var numEnemies:Int = 20;
	private var score:Int = 0;
	private var enemyPointValue:Int = 155;
	private var enemies:Array<Enemy>;
	
	private var levelTimer:FlxTimer;
	private var levelTime:Int = 15;
	private var ticks:Int = 0;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		background = new FlxSprite();
		background.loadGraphic(AssetPaths.gameBackground__png);
		add(background);
		
		txtScore = new FlxText(10, 10, 200, "Score: 0", 20);
		txtTime = new FlxText(10, 30, 200, "Time: 0", 20);
		add(txtScore);
		add(txtTime);
		
		enemies = new Array<Enemy>();
		var enemy:Enemy;
		for (i in 0...numEnemies) {
			enemy = new Enemy();
			add(enemy);
			enemies.push(enemy);
			MouseEventManager.add(enemy, onEnemyMouseDown);
		}
		
		levelTimer = new FlxTimer();
		levelTimer.start(1, onTimeComplete,levelTime);
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		for(i in 0...enemies.length){
			MouseEventManager.remove(enemies[i]);
		}
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
	}
	
	private function onEnemyMouseDown(object:FlxObject):Void{
		object.visible = false;
		score += enemyPointValue;
		txtScore.text = "Score: " + score;
	}
	
	private function onTimeComplete(timer:FlxTimer):Void {
		ticks++;
		txtTime.text = "Time: " + ticks;
		if(ticks >= levelTime){
			var levelEndScreen:LevelEndScreen = new LevelEndScreen(score);
			add(levelEndScreen);
		}
	}
}