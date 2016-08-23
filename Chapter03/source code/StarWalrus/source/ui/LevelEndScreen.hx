package source.ui;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

////////////////////////
//Since we're in a different package, we need to import AssetPaths and Reg
import AssetPaths;
import Reg;

import flixel.ui.FlxButton;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class LevelEndScreen extends FlxState
{
	private var background:FlxSprite;
	
	private var windowHeader:FlxSprite;
	private var newBestScore:FlxSprite;
	private var window:FlxSprite;
	
	private var txtGameScore:FlxText;
	private var txtBestScore:FlxText;
	
	private var btnPlayAgain:FlxButton;
	
	private var windowGroup:FlxGroup;
	
	public function new(score:Int) 
	{
		super();
		
		background = new FlxSprite();
		background.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);//CH7 Revisions
		background.alpha = 0.75;//!!!!! CHANGED from 0.5 !!!
		add(background);
		
		windowGroup = new FlxGroup();
		add(windowGroup);
		windowGroup.visible = false;
		
		windowHeader = new FlxSprite();
		windowHeader.loadGraphic(AssetPaths.levelEndHeader__png);
		windowHeader.setPosition(3000, FlxG.height/2 - windowHeader.height - 71);	//CH7 Revisions
		add(windowHeader);

		window = new FlxSprite();
		window.loadGraphic(AssetPaths.levelEndWindow__png);
		window.setPosition(FlxG.width/2 - window.width/2, FlxG.height/2 - window.height/2); //CH7 Revisions
		windowGroup.add(window);
		
		/*
		REPLACED
		txtGameScore = new FlxText(0, 0, 500, "Final score: " + score + "\nClick to play again", 40);
		txtGameScore.setPosition(FlxG.stage.stageWidth / 2 - txtGameScore.width / 2, FlxG.stage.stageHeight / 2 - txtGameScore.height / 2);
		add(txtGameScore);*/
		
		var newHighScore:Bool = false;
		if(score > Reg.score){
			Reg.score = score;
			newHighScore = true;
		}
		
		txtGameScore = new FlxText(0, 0, 500);
		txtGameScore.text = "SCORE: " + score;
		txtGameScore.setFormat(AssetPaths.BebasNeue__otf, 72, 0x9d4300, "left");
		txtGameScore.setPosition(FlxG.width / 2 - txtGameScore.width / 2 + 20, FlxG.height / 2 - txtGameScore.height - 54);
		windowGroup.add(txtGameScore);
		
		txtBestScore = new FlxText(0, 0, 500); 
		txtBestScore.text = "BEST SCORE: " + Reg.score;
		txtBestScore.setFormat(AssetPaths.BebasNeue__otf, 48, 0xffd800, "left");
		txtBestScore.setPosition(FlxG.width / 2 - 210, FlxG.height / 2 - 2);
		windowGroup.add(txtBestScore);
		
		btnPlayAgain = new FlxButton(0, 0, "PLAY AGAIN", onPlayAgain);
		btnPlayAgain.loadGraphic(AssetPaths.button__png);
		btnPlayAgain.label.setFormat(AssetPaths.BebasNeue__otf, 47, FlxColor.WHITE, "center");
		btnPlayAgain.label.setBorderStyle(FlxText.BORDER_OUTLINE, 0x9d4300, 3);
		btnPlayAgain.setPosition(FlxG.width / 2 - btnPlayAgain.width/2, FlxG.height / 2 + 51);
		windowGroup.add(btnPlayAgain);
		
		if(newHighScore){
			newBestScore = new FlxSprite();
			newBestScore.loadGraphic(AssetPaths.newBestScore__png);
			newBestScore.setPosition(FlxG.width / 2 - 296, FlxG.height / 2 - 45);
			FlxFlicker.flicker(newBestScore, 0, 0.5);
			windowGroup.add(newBestScore);
		}
		
		
		FlxTween.tween(windowHeader, { x:FlxG.width / 2 - windowHeader.width / 2 - 19}, 1.5, { ease: FlxEase.quadIn,complete: onHeaderAnimateIn} );
		FlxG.camera.flash(FlxColor.WHITE, 0.25);
	}
	
	private function onHeaderAnimateIn(tween:FlxTween):Void{
		FlxG.camera.shake();
		windowGroup.visible = true;
	}
	
	override public function update():Void
	{
		//REMOVED
		/*if (FlxG.mouse.justReleased)
		{
			//onPlayAgain();
		}*/
		super.update();
	}
	
	private function onPlayAgain():Void{
		FlxG.resetState();
	}
	
}