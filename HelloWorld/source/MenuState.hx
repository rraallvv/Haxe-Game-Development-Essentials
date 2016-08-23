package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class MenuState extends FlxState
{
	override public function create():Void
	{
		super.create();
		var helloWorldText = new FlxSprite();
		helloWorldText.loadGraphic("assets/images/HelloWorld.png");
		add(helloWorldText);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
