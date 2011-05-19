package fr.mathieudarse.peanut
{
	import com.greensock.TweenNano;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	public class MenuContainer extends Sprite
	{
		[Embed('graphics/Menu_NewBackground.png')]
		private const gfxMenuBg:Class;
		
		private var config:XML;
		//private var background:Bitmap;
		private var currentMenu:Menu;
		
		public function MenuContainer(config:XML)
		{
			super();
			trace('Building menu...');
			this.config = config;
			
			/*background = new gfxMenuBg;
			addChild(background);
			background.y = -960;*/
		}
		
		public function goToMenu(menuId:String):void
		{
			trace('Moving to menu '+menuId+'...');
			var previousMenu:Menu = currentMenu;
			
			var menuConfig:XMLList = config.menu.(@id==menuId);
			var nextMenu:Menu = new Menu(menuConfig);
			nextMenu.x = 960;
			addChild(nextMenu);
			trace('Start moving...');
			
			TweenNano.to(nextMenu, 0.5, {x:0});
			trace('End moving');
		}
	}
}