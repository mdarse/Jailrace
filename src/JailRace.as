package
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.XMLLoader;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	import fr.mathieudarse.peanut.Car;
	import fr.mathieudarse.peanut.Engine;
	import fr.mathieudarse.peanut.HUDisplay;
	import fr.mathieudarse.peanut.MenuContainer;
	import fr.mathieudarse.peanut.Track;
	import fr.mathieudarse.peanut.Vehicle;
	
	//[SWF(width="500", height="450", frameRate="60", backgroundColor="#FFFFFF")]
	[SWF(width="960", height="540", backgroundColor="0xAAAAAA")]
	public class JailRace extends Sprite
	{
		private var _bgShape:Shape;
		private var _bgColor:uint = 0x000000;
		
		private var menu:MenuContainer;
		private var vehicle0:Vehicle;
		private var vehicle1:Vehicle;
		private var engine:Engine;
		private var hud:HUDisplay;
		
		private var _tracks:XML;
		private var _menus:XML;
		
		public function JailRace()
		{
			trace('JailRace started...');
			_init();
		}
		
		private function _init():void
		{
			// Create data loader
			LoaderMax.activate([ImageLoader]);
			var queue:LoaderMax = new LoaderMax({
				name: 'mainQueue', 
				onProgress: onLoaderProgress, 
				onComplete: onLoaderComplete, 
				onError: onLoaderError
			});
			// Load config
			queue.append(new XMLLoader('config/tracks.xml', {name: 'tracks'}));
			queue.append(new XMLLoader('config/menus.xml', {name: 'menus'}));
			queue.load();
			
			initStage(); // Setting stage background and scale options
			//initMenu();
			
			
			createVehicles(); // Creating vehicles
			bindVehiclesKeys(); // Key bindings
			
		}

		private function getTrackXML(id:String):XML
		{
			return _tracks.track.(@id==id)[0];
		}
		
		private function initEngine():void
		{
			engine = new Engine(stage);
			
			engine.loadTrack(getTrackXML('thefirstone'));
			
			engine.addVehicle(vehicle0);
			engine.addVehicle(vehicle1);
			
			trace('Starting engine...');
			engine.start();
		}
		
		private function initStage():void
		{
			trace('Disabling stage scaling...');
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT; // Align stage on top left
			trace('Stage size:', stage.stageWidth, 'x', stage.stageHeight);
			
			// Create a grey rectangle as background
			//initBackground();
		}
		
		private function initBackground():void
		{
			_bgShape = new Shape;
			_bgShape.graphics.beginFill(_bgColor);
			_bgShape.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			_bgShape.graphics.endFill();
			addChildAt(_bgShape, 0);
			stage.addEventListener(Event.RESIZE, onStageResize);
		}
		
		private function onStageResize(e:Event):void
		{
			_bgShape.width = stage.stageWidth;
			_bgShape.height = stage.stageHeight;
			trace('Stage resized to:', stage.stageWidth, 'x', stage.stageHeight);
		}
		
		private function menuLoadedHandler(event:Event):void
		{
			menu = new MenuContainer(new XML(event.target.data));
			addChild(menu);
			menu.goToMenu('home');
		}
		
		private function initMenu():void
		{
			trace('Loading menu configuration...');
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, menuLoadedHandler);
			loader.load(new URLRequest('config/menus.xml'));
		}
		
		private function createVehicles():void
		{
			trace('Creating vehicles...');
			// First vehicle
			vehicle0 = new Car;
			vehicle0.color = 0xff0000;
			vehicle0.draw();
			addChild(vehicle0);
			// Second vehicle
			vehicle1 = new Vehicle;
			vehicle1.color = 0x00ff00;
			vehicle1.draw();
			addChild(vehicle1);
			vehicle1.x += 0;
			vehicle1.y += 40;
		}
		
		private function bindVehiclesKeys():void
		{
			trace('Binding keys...');
			vehicle0.leftKey = Keyboard.LEFT;
			vehicle0.rightKey = Keyboard.RIGHT;
			vehicle0.upKey = Keyboard.UP;
			vehicle0.downKey = Keyboard.DOWN;
			
			vehicle1.leftKey = 65;   // Q key (81)
			vehicle1.rightKey = 68;  // D key (68)
			vehicle1.upKey = 87;     // Z key (90)
			vehicle1.downKey = 83;   // S key (83)
		}
		
		private function onLoaderProgress(event:LoaderEvent):void{
			//trace("progress: " + event.target.progress);
		}
		
		private function onLoaderComplete(event:LoaderEvent):void {
			//trace(event.target + " is complete!");
			
			_tracks = LoaderMax.getContent('tracks');
			_menus = LoaderMax.getContent('menus');
			
			initEngine();
		}
		
		private function onLoaderError(event:LoaderEvent):void {
			trace("error occured with " + event.target + ": " + event.text);
		}
	}
}