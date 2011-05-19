package fr.mathieudarse.peanut
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.net.URLRequest;

	public class Menu extends Sprite
	{
		private var background:Loader;
		
		public function Menu(config:XMLList)
		{
			super();
			
			trace('Loading menu background...');
			background = new Loader();
			background.load(new URLRequest(config.background));
			addChild(background);
		}
	}
}