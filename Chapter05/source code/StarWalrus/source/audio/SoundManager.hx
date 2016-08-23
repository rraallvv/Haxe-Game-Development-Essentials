package audio;

import flixel.FlxG;
import flixel.system.FlxSound;
import flixel.tweens.FlxTween;

class SoundManager
{
	private var shootSound:FlxSound;
	private var damageSound:FlxSound;
	private var explosion1Sound:FlxSound;
	private var explosion2Sound:FlxSound;
	
	
	//Singleton setup
	public static var instance(get, null):SoundManager;
    private static function get_instance():SoundManager {
        if(instance == null) {
            instance = new SoundManager();
        }
        return instance;
    }
	
	
	private function new() 
	{
		shootSound = FlxG.sound.load(Sounds.SOUND_SHOOT, Sounds.VOLUME_SHOOT);
		shootSound.persist = true;
		
		damageSound = FlxG.sound.load(Sounds.SOUND_DAMAGE, Sounds.VOLUME_DAMAGE);
		damageSound.persist = true;
		
		explosion1Sound = FlxG.sound.load(Sounds.SOUND_EXPLOSION1, Sounds.VOLUME_EXPLOSION1);
		explosion1Sound.persist = true;
		
		explosion2Sound = FlxG.sound.load(Sounds.SOUND_EXPLOSION2, Sounds.VOLUME_EXPLOSION2);
		explosion2Sound.persist = true;
	}
	
	
	public function playFanfareMusic():Void{
		FlxG.sound.playMusic(Sounds.MUSIC_FANFARE, Sounds.VOLUME_FANFARE);
	}
	
	public function playInGameMusic():Void{
		FlxG.sound.playMusic(Sounds.MUSIC_INGAME,  Sounds.VOLUME_INGAME);
	}
	
	public function playWhooshSound(delay:Float):Void {
		var timeout:Float = 1;
		FlxTween.num(timeout, 0, delay, { complete:function(tween:FlxTween) {
			FlxG.sound.play(Sounds.SOUND_WHOOSH,Sounds.VOLUME_WHOOSH);
		} 
		});
	}
	
	public function playTingSound():Void{
		FlxG.sound.play(Sounds.SOUND_TING,Sounds.VOLUME_TING);
	}
	
	public function playClickSound():Void{
		FlxG.sound.play(Sounds.SOUND_CLICK,Sounds.VOLUME_CLICK);
	}
	
	public function playShootSound():Void{
		shootSound.play(true);
	}
	
	public function playDamageSound():Void{
		damageSound.play(true);
	}
	
	public function playExplosion(explosionNumber:Int):Void {
		switch(explosionNumber){
			case 0:
				explosion1Sound.play(true);
			case 1:
				explosion2Sound.play(true);
		}
	}
}