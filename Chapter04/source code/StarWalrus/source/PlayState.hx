package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

import source.ui.LevelEndScreen;
import flixel.plugin.MouseEventManager;
import flixel.FlxObject;
import flixel.util.FlxTimer;

import ui.GameHUD;
import flixel.group.FlxGroup;

import flixel.group.FlxTypedGroup;
import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxColor;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	private var background:FlxBackdrop;
	private var backgroundScrollSpeed:Float = -200;
	
	private var gameHud:GameHUD;
	
	private var enemyLayer:FlxGroup;
	private var numEnemies:Int = 20;
	private var score:Int = 0;
	private var enemyPointValue:Int = 155;
	
	private var levelTimer:FlxTimer;
	private var levelTime:Int = 15;
	private var ticks:Int = 0;
	
	private var player:Player;
	private var playerLayer:FlxGroup;
	private var health:Int = 3;
	
	private var explosions:FlxTypedGroup<ExplosionEffect>;
	private var maxExplosions:Int = 40;
	
	private var pointsPerSecond:Int = 5;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
			background = new FlxBackdrop(AssetPaths.gameBackground__png);
			background.velocity.x = backgroundScrollSpeed;
			add(background);
			
			
			enemyLayer = new FlxGroup();
			add(enemyLayer);
			
			player = new Player();
			playerLayer = new FlxGroup();
			
			playerLayer.add(player);
			add(playerLayer);
			
			explosions = new FlxTypedGroup<ExplosionEffect>(maxExplosions);
			var explosionEffect:ExplosionEffect;
			
			for(i in 0...maxExplosions){
				explosionEffect = new ExplosionEffect();
				explosionEffect.kill();
				explosions.add(explosionEffect);
			}
			playerLayer.add(explosions);

			gameHud = new GameHUD();
			add(gameHud);
			
			var enemy:Enemy;
			for (i in 0...numEnemies) {
				enemy = new Enemy();
				enemyLayer.add(enemy);
			}
			
			
			levelTimer = new FlxTimer();
			levelTimer.start(1, onTimeComplete, 0);
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
		if(player != null){
			FlxG.overlap(player.projectiles, enemyLayer, onProjectileCollision);
			FlxG.overlap(player.sprite, enemyLayer, onEnemyCollision);
		}
	}
	
	private function onProjectileCollision(projectile:FlxObject,enemy:FlxObject):Void {
		projectile.kill();
		
		if(enemy.x < (FlxG.stage.stageWidth - 10) && Std.is(enemy, Enemy)){
			killEnemy(cast(enemy, Enemy));
			updateScore(enemyPointValue);
		}
	}
	
	private function onEnemyCollision(playerObject:FlxObject,enemy:FlxObject):Void {
		if(Std.is(enemy, Enemy)){
			killEnemy(cast(enemy, Enemy), 0.1);
			FlxG.camera.flash(FlxColor.RED, 0.15);
			health--;
			gameHud.setHealth(health);
			if (health == 0) {
				player.killPlayer();
				levelTimer.cancel();
				var levelEndScreen:LevelEndScreen = new LevelEndScreen(score);
				add(levelEndScreen);
			}
		}
	}
	
	private function killEnemy(enemy:Enemy, shakeStrength:Float = 0.005):Void{
		enemy.killEnemy();
		var explosion:ExplosionEffect = explosions.recycle();
		explosion.playExplosion(enemy.x, enemy.y);
		FlxG.camera.shake(shakeStrength, 0.5);
		
		explosions.forEachAlive(function(currentExplosion:ExplosionEffect) {
				if (currentExplosion.animationComplete) {
					currentExplosion.kill();
				}
			} );
	}
	
	
	private function onTimeComplete(timer:FlxTimer):Void {
		ticks++;
		updateScore(pointsPerSecond);

	}
	
	private function updateScore(points:Int):Void{
		score += points;
		gameHud.setScore(score);
	}
}