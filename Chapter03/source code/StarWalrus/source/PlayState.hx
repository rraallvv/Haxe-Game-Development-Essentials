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

//New imports
import ui.GameHUD;
import flixel.group.FlxGroup;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	private var background:FlxSprite;
	private var gameHud:GameHUD;//NEW
	//private var txtScore:FlxText; //REMOVED
	//private var txtTime:FlxText; //REMOVED
	
	
	private var enemyLayer:FlxGroup;//NEW
	private var numEnemies:Int = 20;
	private var score:Int = 0;
	private var enemyPointValue:Int = 155;
	
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
			
			//REMOVED
			/*txtScore = new FlxText(10, 10, 200, "Score: 0", 20);
			txtTime = new FlxText(10, 30, 200, "Time: 0", 20);
			add(txtScore);
			add(txtTime);*/
			
			//NEW
			////////////////////////////////////////////
			enemyLayer = new FlxGroup();
			add(enemyLayer);
			
			gameHud = new GameHUD();
			add(gameHud);
			/////////////////////////////////////////
			
			var enemy:Enemy;
			for (i in 0...numEnemies) {
				enemy = new Enemy();
				enemyLayer.add(enemy);//NEW
				
				MouseEventManager.add(enemy, onEnemyMouseDown);
			}
			
			levelTimer = new FlxTimer();
			levelTimer.start(1, onTimeComplete, levelTime);
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
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
		gameHud.setScore(score);//ADDED
		//txtScore.text = "Score: " + score;//REMOVED
	}
	
	private function onTimeComplete(timer:FlxTimer):Void {
		ticks++;
		//txtTime.text = "Time: " + ticks; //REMOVED
		if(ticks >= levelTime){
			var levelEndScreen:LevelEndScreen = new LevelEndScreen(score);
			add(levelEndScreen);
		}
	}
}