package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

////////////////////////////
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxSpriteUtil;
/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	
	private var background:FlxSprite;
	private var star:FlxSprite;
	private var logo:FlxSprite;
	
	public var checkForInput:Bool = false;
	private var txtInstructions:FlxText;
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();

		background = new FlxSprite();
		background.loadGraphic(AssetPaths.titleScreenBackground__png);
		background.visible = false;
		FlxSpriteUtil.screenCenter(background);
		add(background);
		
		star = new FlxSprite();
		star.loadGraphic(AssetPaths.titleScreenStar__png);
		star.setPosition(3000, 276);
		add(star);

		logo = new FlxSprite();
		logo.loadGraphic(AssetPaths.titleScreenLogo__png);
		logo.setPosition(59, 360);
		logo.visible = false;
		add(logo);
		

		txtInstructions = new FlxText(0, 0, 500);
		txtInstructions.text = "- TAP TO START -";
		txtInstructions.setFormat(AssetPaths.BebasNeue__otf, 72, FlxColor.WHITE, "center");
		txtInstructions.setBorderStyle(FlxText.BORDER_OUTLINE, FlxColor.BLACK, 3);
		
		txtInstructions.setPosition(FlxG.width / 2 - txtInstructions.width / 2, 0);
		txtInstructions.visible = false;
		
		add(txtInstructions);
		
		FlxTween.tween(star, { x:0 }, 1.0, { ease: FlxEase.quadIn,complete: onStarAnimateIn} );
	}
	
	private function onStarAnimateIn(tween:FlxTween):Void{
		
		logo.visible = true;
		FlxG.camera.flash(FlxColor.WHITE, 0.25, onFlashComplete);
		FlxG.camera.shake();
		background.visible = true;
	}
	
	private function onFlashComplete():Void{
		FlxFlicker.flicker(txtInstructions, 0, 0.5);
		
		checkForInput = true;
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
		
		if (checkForInput && FlxG.mouse.justReleased)
		{
			goToGame();
		}
	}
	
	private function goToGame():Void {
		FlxG.camera.fade(FlxColor.BLACK,0.5, false,function() {
			FlxG.switchState(new PlayState());
		});
		
	}
	
}