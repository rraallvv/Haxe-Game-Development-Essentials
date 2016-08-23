package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

import flixel.input.mouse.FlxMouseEventManager;
import flixel.FlxObject;
import flixel.util.FlxTimer;

import source.ui.LevelEndScreen;

import ui.GameHUD;
import flixel.group.FlxGroup;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxColor;

import audio.SoundManager;

class PlayState extends FlxState
{
	private var background:FlxBackdrop;
	private var backgroundScrollSpeed:Float = -200;

	private var player:Player;
	private var playerLayer:FlxGroup;
	private var health:Int = 3;

	private var explosions:FlxTypedGroup<ExplosionEffect>;
	private var maxExplosions:Int = 40;

	private var score:Int = 0;
	private var enemyPointValue:Int = 155;

	private var levelTimer:FlxTimer;
	private var levelTime:Int = 15;
	private var ticks:Int = 0;

	private var gameHud:GameHUD;
	private var enemyLayer:EnemySpawner;

	private var pointsPerSecond:Int = 5;

	override public function create():Void
	{
		super.create();

		background = new FlxBackdrop("assets/images/gameBackground.png");
		background.velocity.x = backgroundScrollSpeed;
		add(background);

		enemyLayer = new EnemySpawner();
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

		levelTimer = new FlxTimer();
		levelTimer.start(1, onTimeComplete, 0);

		SoundManager.instance.playInGameMusic();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if(player != null){
			FlxG.overlap(player.projectiles, enemyLayer, onProjectileCollision);
			FlxG.overlap(player.sprite, enemyLayer, onEnemyCollision);
		}
	}

	private function onEnemyMouseDown(object:FlxObject):Void{
		object.visible = false;
		score += enemyPointValue;
		gameHud.setScore(score);
	}	

	override function destroy() {
		super.destroy();
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
			SoundManager.instance.playDamageSound();
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
