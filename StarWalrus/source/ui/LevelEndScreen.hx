package source.ui;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

import flixel.ui.FlxButton;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

import Reg;

import audio.SoundManager;

import ui.Strings;
import ui.StringIDs;

class LevelEndScreen extends FlxState
{
	private var background:FlxSprite;
	private var txtGameScore:FlxText;
	
	private var windowHeader:FlxSprite;
	private var newBestScore:FlxSprite;
	private var window:FlxSprite;

	private var txtBestScore:FlxText;
	private var btnPlayAgain:FlxButton;

	private var windowGroup:FlxGroup;

	public function new(score:Int)
	{
		super();
		background = new FlxSprite();
		background.makeGraphic(FlxG.stage.stageWidth, FlxG.stage.stageHeight, FlxColor.BLACK);
		background.alpha = 0.75;
		add(background);

		windowGroup = new FlxGroup();
		add(windowGroup);
		windowGroup.visible = false;

		windowHeader = new FlxSprite();
		windowHeader.loadGraphic("assets/images/levelEndHeader.png");
		windowHeader.setPosition(3000, FlxG.height / 2 - windowHeader.height - 71);
		add(windowHeader);

		window = new FlxSprite();
		window.loadGraphic("assets/images/levelEndWindow.png");
		window.setPosition(FlxG.width/2 - window.width/2, FlxG.height/2 - window.height/2);
		windowGroup.add(window);	

		var newHighScore:Bool = false;

		if(score > Reg.score){
			Reg.score = score;
			newHighScore = true;
		}

		txtGameScore = new FlxText(0, 0, 500);
		txtGameScore.text = Strings.instance.getValue(StringIDs.SCORE) + score;
		txtGameScore.setFormat("assets/fonts/BebasNeue.otf", 72, 0x9d4300, "left");
		txtGameScore.setPosition(FlxG.width / 2 - txtGameScore.width / 2 + 20, FlxG.height / 2 - txtGameScore.height - 54);
		windowGroup.add(txtGameScore);
		
		txtBestScore = new FlxText(0, 0, 500); 
		txtBestScore.text = Strings.instance.getValue(StringIDs.BEST_SCORE) + Reg.score;
		txtBestScore.setFormat("assets/fonts/BebasNeue.otf", 48, 0xffd800, "left");
		txtBestScore.setPosition(FlxG.width / 2 - 210, FlxG.height / 2 - 2);
		windowGroup.add(txtBestScore);

		btnPlayAgain = new FlxButton(0, 0, Strings.instance.getValue(StringIDs.PLAY_AGAIN), onPlayAgain);
		btnPlayAgain.loadGraphic("assets/images/button.png");
		btnPlayAgain.label.setFormat("assets/fonts/BebasNeue.otf", 47, FlxColor.WHITE, "center");
		btnPlayAgain.label.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0x9d4300, 3);
		btnPlayAgain.setPosition(FlxG.width / 2 - btnPlayAgain.width/2, FlxG.height / 2 + 51);
		windowGroup.add(btnPlayAgain);

		if(newHighScore){
			newBestScore = new FlxSprite();
			newBestScore.loadGraphic("assets/images/newBestScore.png");
			newBestScore.setPosition(FlxG.width / 2 - 296, FlxG.height / 2 - 45);
			FlxFlicker.flicker(newBestScore, 0, 0.5);
			windowGroup.add(newBestScore);
		}
		
		FlxTween.tween(windowHeader, { x:FlxG.width / 2 - windowHeader.width / 2 - 19}, 1.5, { ease: FlxEase.quadIn, onComplete: function (tween:FlxTween):Void{
			FlxG.camera.shake();
			windowGroup.visible = true;
			SoundManager.instance.playTingSound();
		}});
		FlxG.camera.flash(FlxColor.WHITE, 0.25);

		SoundManager.instance.playFanfareMusic();
		SoundManager.instance.playWhooshSound(1);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	private function onPlayAgain():Void{
		FlxG.camera.fade(FlxColor.BLACK,0.5, false,function() {
			FlxG.resetState();
		});
		SoundManager.instance.playClickSound();
	}
}
