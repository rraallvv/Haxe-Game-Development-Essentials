package ui;

import flixel.group.FlxGroup;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
/**
 * ...
 * @author ...
 */
class GameHUD extends FlxGroup
{
	private var background:FlxSprite;

	private var txtHealthHeader:FlxText;
	private var healthHearts:Array<FlxSprite>;
	private var maxHealth:Int = 3;
	private var heartPadding:Int = 14;
	
	private var txtScore:FlxText;
	
	public function new() 
	{
		super();
		
		background = new FlxSprite();
		background.loadGraphic(AssetPaths.hudBackground__png);
		background.setPosition(6,18);
		add(background);

		txtHealthHeader = new FlxText(37, 14, 500);
		txtHealthHeader.text = "HEALTH:";
		txtHealthHeader.setFormat(AssetPaths.BebasNeue__otf, 36, FlxColor.WHITE, "left");
		add(txtHealthHeader);
		
		txtScore = new FlxText(62, 52, 500); 
		txtScore.text = "SCORE: " + 0;
		txtScore.setFormat(AssetPaths.BebasNeue__otf, 30, 0x9d4300, "left");
		add(txtScore);
		
		healthHearts = new Array<FlxSprite>();
		var healthHeart:FlxSprite;
		for (i in 0...maxHealth) {
			healthHeart = new FlxSprite();
			healthHeart.loadGraphic(AssetPaths.healthHeartOn__png);
			healthHeart.setPosition(132 + (i * (healthHeart.width + heartPadding)),22);
			add(healthHeart);
			healthHearts.push(healthHeart);
		}

	}
	
	public function setScore(score:Int):Void{
		txtScore.text = "SCORE: " + score;
	}
	
}