package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxSpriteUtil;

import audio.SoundManager;

import ui.Strings;
import ui.StringIDs;

class MenuState extends FlxState
{
	private var background:FlxSprite;
	private var star:FlxSprite;
	private var logo:FlxSprite;
	public var checkForInput:Bool = false;
	private var txtInstructions:FlxText;

	override public function create():Void
	{
		super.create();

		Strings.instance.init();

		var test = new FlxSprite();
		test.loadGraphic("assets/images/gameBackground.png");
		add(test);

		background = new FlxSprite();
		background.loadGraphic("assets/images/titleScreenBackground.png");
		background.visible = false;
		background.screenCenter();
		add(background);

		star = new FlxSprite();
		star.loadGraphic("assets/images/titleScreenStar.png");
		star.setPosition(3000, 276);
		add(star);

		logo = new FlxSprite();
		logo.loadGraphic("assets/images/titleScreenLogo.png");
		logo.setPosition(59, 360);
		logo.visible = false;
		add(logo);

		txtInstructions = new FlxText(0, 0, 500);
		txtInstructions.text = Strings.instance.getValue(StringIDs.TAP_TO_START);
		txtInstructions.setFormat("assets/fonts/BebasNeue.otf", 72, FlxColor.WHITE, "center");
		txtInstructions.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 3);

		txtInstructions.setPosition(FlxG.width / 2 - txtInstructions.width / 2, 0);
		txtInstructions.visible = false;

		add(txtInstructions);

		FlxTween.tween(star, { x:0 }, 1.0, { ease: FlxEase.quadIn, onComplete: function (tween:FlxTween):Void {
				logo.visible = true;
				FlxG.camera.shake();
				background.visible = true;
				SoundManager.instance.playTingSound();
				FlxG.camera.flash(FlxColor.WHITE, 0.25, function ():Void {
					FlxFlicker.flicker(txtInstructions, 0, 0.5);
					checkForInput = true;
				});
  			}
	  	});

		SoundManager.instance.playFanfareMusic();
		SoundManager.instance.playWhooshSound(0.75);		  
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (checkForInput && 
#if mobile
		FlxG.touches.justReleased().length > 0
#else
		FlxG.mouse.justReleased
#end
		)
		{
  			goToGame();
		}
	}

	private function goToGame():Void {
  		FlxG.camera.fade(FlxColor.BLACK,0.5, false, function() {
    		FlxG.switchState(new PlayState());
  		});
		SoundManager.instance.playClickSound();
	}
}
