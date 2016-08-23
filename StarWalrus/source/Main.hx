package;

import flixel.FlxGame;
import openfl.Lib;
import openfl.display.Sprite;
import flixel.FlxState;

class Main extends Sprite
{
	var gameWidth:Int = 960;
	var gameHeight:Int = 640;
	var initialState:Class<FlxState> = MenuState;

	public function new()
	{
		super();
		addChild(new FlxGame(gameWidth, gameHeight, initialState));
	}
}
