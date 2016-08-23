package;

import flixel.FlxSprite;
import flixel.group.FlxGroup;

import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxTimer;

import audio.SoundManager;

import flixel.input.touch.FlxTouch;

class Player extends FlxGroup
{
	public var sprite:FlxSprite;
	
	public var projectiles:FlxTypedGroup<Projectile>; 
	private var maxProjectiles:Int = 20;
	private var shootSpeed:Float = 0.5;
	private var shootTimer:FlxTimer;
	
	private var muzzleFlash:MuzzleFlash;
	
	private var movementSpeed:Float = 10;
	private var mouseDeadzone:Float = 30;
	
	private var maxY:Int = 500;
	private var minY:Int = 0;
	
	private var maxX:Int = 600;
	private var minX:Int = -100;
	
	public function new() 
	{
		super();

		var textureAtlasFrames = FlxAtlasFrames.fromTexturePackerJson("assets/images/ingameSprites.png", "assets/data/ingameSprites.json");

		sprite = new FlxSprite();
		sprite.frames = textureAtlasFrames;
		
		sprite.animation.addByNames("Loop", ["player01.png","player02.png"], 8);
		sprite.animation.play("Loop");
		sprite.setPosition(minX, FlxG.height / 2 - sprite.height/2);
		
		add(sprite);
		
		projectiles = new FlxTypedGroup<Projectile>(maxProjectiles);
		
		var projectile:Projectile;		
		for(i in 0...maxProjectiles){
			projectile = new Projectile();
			projectiles.add(projectile);
			projectile.kill();
		}
		
		add(projectiles);
		
		muzzleFlash = new MuzzleFlash();
		add(muzzleFlash);
		
		shootTimer = new FlxTimer();
		shootTimer.start(shootSpeed, onShoot, 0);
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

#if mobile
		if (FlxG.touches.justStarted().length > 0) 
		{
			var touch:FlxTouch = FlxG.touches.getFirst();

			if (touch.y - sprite.height / 2   < (sprite.y + sprite.height / 2) && 
				Math.abs((sprite.y + sprite.height / 2) - (touch.y - sprite.height / 2)) > mouseDeadzone){
				moveUp();
			}else if ((touch.y - sprite.height / 2) > (sprite.y + sprite.height / 2) && 
				Math.abs((touch.y - sprite.height / 2) - (sprite.y + sprite.height / 2)) > mouseDeadzone){
				moveDown();
			}
			
			if (touch.x - sprite.width / 2   < (sprite.x + sprite.width / 2) && 
				Math.abs((sprite.x + sprite.width / 2) - (touch.x - sprite.width / 2)) > mouseDeadzone){
				moveLeft();
			}else if ((touch.x - sprite.width / 2) > (sprite.x + sprite.width / 2) && 
				Math.abs((touch.x - sprite.width / 2) - (sprite.x + sprite.width / 2)) > mouseDeadzone){
				moveRight();
			}
		}
#else
		if (FlxG.keys.pressed.UP || FlxG.keys.pressed.W) 
		{
			moveUp();
		}else if(FlxG.keys.pressed.DOWN|| FlxG.keys.pressed.S){
			moveDown();
		}
		
		if (FlxG.keys.pressed.RIGHT || FlxG.keys.pressed.D) 
		{
			moveRight();
		}else if(FlxG.keys.pressed.LEFT|| FlxG.keys.pressed.A){
			moveLeft();
		}

		if (FlxG.mouse.pressed) 
		{
			if (FlxG.mouse.y - sprite.height / 2   < (sprite.y + sprite.height / 2) && 
				Math.abs((sprite.y + sprite.height / 2) - (FlxG.mouse.y - sprite.height / 2)) > mouseDeadzone){
				moveUp();
			}else if ((FlxG.mouse.y - sprite.height / 2) > (sprite.y + sprite.height / 2) && 
				Math.abs((FlxG.mouse.y - sprite.height / 2) - (sprite.y + sprite.height / 2)) > mouseDeadzone){
				moveDown();
			}
			
			if (FlxG.mouse.x - sprite.width / 2   < (sprite.x + sprite.width / 2) && 
				Math.abs((sprite.x + sprite.width / 2) - (FlxG.mouse.x - sprite.width / 2)) > mouseDeadzone){
				moveLeft();
			}else if ((FlxG.mouse.x - sprite.width / 2) > (sprite.x + sprite.width / 2) && 
				Math.abs((FlxG.mouse.x - sprite.width / 2) - (sprite.x + sprite.width / 2)) > mouseDeadzone){
				moveRight();
			}
		}
#end		
	}
	
	private function moveUp():Void {
		if(sprite.y > minY){
			sprite.y -= movementSpeed;
		}
	}
	
	private function moveDown():Void {
		if(sprite.y < maxY){
			sprite.y += movementSpeed;
		}
	}
	
	private function moveRight():Void {
		if(sprite.x < maxX){
			sprite.x += movementSpeed;
		}
	}
	
	private function moveLeft():Void {
		if(sprite.x > minX){
			sprite.x -= movementSpeed;
		}
	}
	
	private function onShoot(timer:FlxTimer):Void {
		var projectile = projectiles.recycle();
		projectile.x = sprite.x + 230;
		projectile.y = sprite.y + 100;
		
		projectiles.forEachAlive(function(currentProjectile:Projectile) {
			if(currentProjectile.x > (FlxG.stage.stageWidth + currentProjectile.width)){
				currentProjectile.kill();
			}
		} );
		
		muzzleFlash.playFlash(sprite.x, sprite.y);

		SoundManager.instance.playShootSound();		
	}
	
	public function killPlayer():Void{
		shootTimer.cancel();
		this.kill();
	}
	
}
