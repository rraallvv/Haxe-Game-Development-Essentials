package ui;

import haxe.xml.Fast;
import openfl.Assets;

class Strings
{
	
    private var fast:Fast;
	
	public function init():Void{
		var stringXML = Xml.parse(Assets.getText("assets/data/strings.xml"));
        fast = new Fast(stringXML.firstElement());
	}
	
	public function getValue(id:String):String{
		for(string in fast.nodes.string){
			if (id == string.att.id) {
				return string.innerData;
			}
		}
		
		return "";
		
	}
	
	//Singleton setup
	public static var instance(get, null):Strings;
    private static function get_instance():Strings {
        if(instance == null) {
            instance = new Strings();
        }
        return instance;
    }
	
	private function new() {}
	
}