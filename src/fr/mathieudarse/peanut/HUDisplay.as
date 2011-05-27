package fr.mathieudarse.peanut
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.engine.TextElement;
	
	public class HUDisplay extends Sprite
	{
		public var textField:TextField;
		public var collides:TextField;
		
		public function HUDisplay()
		{
			super();
			
			textField = new TextField();
			textField.defaultTextFormat = new TextFormat('Verdana', 12, 0xff0000);
			addChild(textField);
			
			collides = new TextField();
			collides.defaultTextFormat = new TextFormat('Verdana', 12, 0x00ff00);
			collides.x = 100;
			collides.width = 400;
			addChild(collides);
		}
	}
}