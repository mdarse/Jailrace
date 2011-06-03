package fr.mathieudarse.peanut
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class HUDisplay extends Sprite
	{
		private var _textField:TextField;
		private var _color:uint = 0xAAAAAA;
		private var _fontsize:uint = 10;
		private var _font:String = 'Verdana';
		
		public var collides:TextField;
		
		public function HUDisplay()
		{
			super();
			
			_textField = new TextField();
			_textField.defaultTextFormat = new TextFormat(_font, _fontsize, _color);
			addChild(_textField);
			
			collides = new TextField();
			collides.defaultTextFormat = new TextFormat('Verdana', 10, 0x00ff00);
			collides.x = 100;
			collides.width = 400;
			addChild(collides);
		}
		
		public function setSpeed(v0:Number, v1:Number):void
		{
			// Updating speed on HUD
			_textField.text = "V1 speed: "+String(v0)+"\nV2 speed: "+String(v1);
		}
	}
}