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
	
	import fr.mathieudarse.peanut.Engine;
	import fr.mathieudarse.peanut.HUDisplay;
	import fr.mathieudarse.peanut.Track;
	import fr.mathieudarse.peanut.UI;
	import fr.mathieudarse.peanut.Vehicle;
	
	//[SWF(width="500", height="450", frameRate="60", backgroundColor="#FFFFFF")]
	[SWF(width="960", height="540", backgroundColor="#AAAAAA")]
	public class JailRace extends Sprite
	{
		private var _ui:UI;
		private var _hud:HUDisplay;
		private var _engine:Engine;
		
		private var _tracksConfig:XML;
		private var _vehiclesConfig:XML;
		private var _menusConfig:XML;
		private var _hudConfig:XML;
		
		public function JailRace()
		{
			trace('JailRace started...');
			// Setting stage background and scale options
			initStage();
			
			// Create data loader
			LoaderMax.activate([ImageLoader]);
			var queue:LoaderMax = new LoaderMax({
				name: 'mainQueue', 
				onProgress: onLoaderProgress, 
				onComplete: init, 
				onError: onLoaderError
			});
			// Load config
			queue.append(new XMLLoader('config/tracks.xml', {name: 'tracks'}));
			queue.append(new XMLLoader('config/vehicles.xml', {name: 'vehicles'}));
			queue.append(new XMLLoader('config/menus.xml', {name: 'menus'}));
			queue.append(new XMLLoader('config/hud.xml', {name: 'hud'}));
			queue.load();
		}
		
		private function init(e:LoaderEvent):void
		{
			// Store configuration
			_tracksConfig = LoaderMax.getContent('tracks');
			_vehiclesConfig = LoaderMax.getContent('vehicles');
			_menusConfig = LoaderMax.getContent('menus');
			_hudConfig = LoaderMax.getContent('hud');
			
			_ui = new UI(stage, _menusConfig);
			//_ui.show();
			//_ui.goHome();
			
			_hud = new HUDisplay(stage, _hudConfig);
			addChild(_hud);
			_engine = new Engine(stage);
			initEngine();
			_engine.start();
		}
		
		private function initEngine():void
		{
			var tConfig:XML = _tracksConfig.track.(@id=='crymap')[0];
			_engine.loadTrack(tConfig);
			
			var vConf0:XML = _vehiclesConfig.vehicle.(@id=='jailmobile')[0];
			var v0:Vehicle = new Vehicle(stage, vConf0);
			v0.setCommandKeys(Keyboard.UP, Keyboard.DOWN, Keyboard.LEFT, Keyboard.RIGHT, Keyboard.ENTER);
			_engine.addVehicle(v0);
			
			var vConf1:XML = _vehiclesConfig.vehicle.(@id=='racemobile')[0];
			var v1:Vehicle = new Vehicle(stage, vConf1);
			v1.setCommandKeys(87, 83, 65, 68, Keyboard.TAB);
			_engine.addVehicle(v1);
			
		}
		
		private function initStage():void
		{
			trace('Disabling stage scaling...');
			//stage.scaleMode = StageScaleMode.NO_SCALE;
			//stage.align = StageAlign.TOP_LEFT; // Align stage on top left
			trace('Stage size:', stage.stageWidth, 'x', stage.stageHeight);
			stage.frameRate = 30;
			stage.addEventListener(Event.RESIZE, onStageResize);
		}
		
		private function onStageResize(e:Event):void
		{
			trace('Stage resized to:', stage.stageWidth, 'x', stage.stageHeight);
		}
		
		/*private function bindVehiclesKeys():void
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
		}*/
		
		private function onLoaderProgress(event:LoaderEvent):void{
			//trace("progress: " + event.target.progress);
		}
		
		private function onLoaderError(event:LoaderEvent):void {
			trace("error occured with " + event.target + ": " + event.text);
			var s:Shape = new Shape;
			s.graphics.beginFill(0xFF0000);
			s.graphics.drawRect(0,0,20,20);
			s.graphics.endFill();
			addChild(s);
		}
	}
}