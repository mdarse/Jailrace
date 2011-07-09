package fr.mathieudarse.peanut
{
	import com.greensock.loading.LoaderMax;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class HUDisplay extends Sprite
	{
		/*private var _textField:TextField;
		private var _color:uint = 0xAAAAAA;
		private var _fontsize:uint = 10;
		private var _font:String = 'Verdana';*/
		private var _stage:Stage;
		private var _config:XML;
		
		public function HUDisplay(stage:Stage, config:XML)
		{
			super();
			_stage = stage;
			_config = config;
			
			/*_textField = new TextField();
			_textField.defaultTextFormat = new TextFormat(_font, _fontsize, _color);
			_textField.width = 100;
			_textField.height = 30;
			addChild(_textField);*/
			
			var p1:Bitmap = LoaderMax.getContent('hud_player1').rawContent;
			var p1Life:Shape = new Shape;
			p1Life.graphics.beginFill(0xFF0000, .8);
			p1Life.graphics.drawRect(22, 18, 59, 22);
			p1Life.graphics.endFill();
			addChild(p1Life);
			addChild(p1);
			
			var p2:Bitmap = LoaderMax.getContent('hud_player2').rawContent;
			p2.x = 800;
			var p2Life:Shape = new Shape;
			p2Life.graphics.beginFill(0xFF0000, .8);
			p2Life.graphics.drawRect(882, 19, 59, 22);
			p2Life.graphics.endFill();
			addChild(p2Life);
			addChild(p2);
		}
		
		public function setSpeed(v0:Number, v1:Number):void
		{
			// Updating speed on HUD
			//_textField.text = "V1 speed: "+String(v0)+"\nV2 speed: "+String(v1);
		}
	}
}