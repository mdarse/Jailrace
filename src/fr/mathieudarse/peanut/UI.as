package fr.mathieudarse.peanut
{
	import com.greensock.loading.LoaderMax;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.Stage;
	
	public class UI extends Sprite
	{
		private var _hidden:Boolean = false;
		private var _stage:Stage;
		private var _config:XML;
		private var _background:Bitmap;
		
		public function UI(stage:Stage, config:XML)
		{
			super();
			_stage = stage;
			_config = config;
			
			// Global background
			_background = LoaderMax.getContent(config.background).rawContent;
			addChild(_background);
		}
		
		public function show():void
		{
			_stage.addChild(this);
		}
		
		public function hide():void
		{
			_stage.removeChild(this);
		}
		
		public function goHome():void
		{
			// Create elements
			
			
			
		}
	}
}