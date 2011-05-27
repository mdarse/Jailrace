package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	
	import fr.mathieudarse.peanut.Car;
	import fr.mathieudarse.peanut.Engine;
	import fr.mathieudarse.peanut.HUDisplay;
	import fr.mathieudarse.peanut.MenuContainer;
	import fr.mathieudarse.peanut.SuperCar;
	import fr.mathieudarse.peanut.Vehicle;
	
	import org.cove.ape.*;
	
	import uk.co.bigroom.input.KeyPoll;
	
	//[SWF(width="500", height="450", frameRate="60", backgroundColor="#FFFFFF")]
	[SWF(width="960", height="540")]
	public class JailRace extends Sprite
	{
		private var bgShape:Sprite;
		private var bgColor:uint = 0xAAAAAA;
		
		private var menu:MenuContainer;
		private var vehicle0:Vehicle;
		private var vehicle1:Vehicle;
		private var engine:Engine;
		private var hud:HUDisplay;
		private var data:XML;
		
		private var keyPoll:KeyPoll;
		private var sc:SuperCar;
		
		public function JailRace()
		{
			trace('JailRace started...');
			initStage(); // Setting stage background and scale options
			//initMenu();
			
			// Phisics
			initPhysics();
			
			/*createVehicles(); // Creating vehicles
			bindVehiclesKeys(); // Key bindings
			
			// Engine stuff
			engine = new Engine(this.stage);
			engine.addVehicle(vehicle0);
			engine.addVehicle(vehicle1);
			createHUD(); // Head up display (HUD)
			trace('Starting engine...');
			engine.start();*/
		}
		
		private function initStage():void
		{
			trace('Disabling stage scaling...');
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT; // Align stage on top left
			trace('Stage size:', stage.stageWidth, 'x', stage.stageHeight);
			// Creates background
			bgShape = new Sprite;
			bgShape.graphics.beginFill(bgColor);
			bgShape.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			bgShape.graphics.endFill();
			addChildAt(bgShape, 0);
			stage.addEventListener(Event.RESIZE, updateBackgroundSize);
		}
		
		private function updateBackgroundSize(e:Event):void
		{
			bgShape.width = stage.stageWidth;
			bgShape.height = stage.stageHeight;
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
		
		private function createHUD():void
		{
			trace('Creating head up display...');
			hud = new HUDisplay;
			addChild(hud);
			engine.hud = hud;
		}
		
		private function initPhysics():void {
			
			APEngine.init(1/4);
			APEngine.container = this;
			//APEngine.constraintCollisionCycles = 30;
				
			// Gravity
			//APEngine.addMasslessForce(new org.cove.ape.Vector(0, 4));
			
			APEngine.damping = .99;
			
			var defaultGroup:Group = new Group();
			defaultGroup.collideInternal = true;
			
			// Borders
			var borderWidth:uint = 10;
			var bt:RectangleParticle = new RectangleParticle(stage.width/2, borderWidth/2, stage.width, borderWidth, 0, true);
			defaultGroup.addParticle(bt);
			var bb:RectangleParticle = new RectangleParticle(stage.width/2, stage.height-borderWidth/2, stage.width, borderWidth, 0, true);
			defaultGroup.addParticle(bb);
			var bl:RectangleParticle = new RectangleParticle(borderWidth/2, stage.height/2, borderWidth, stage.height, 0, true);
			defaultGroup.addParticle(bl);
			var br:RectangleParticle = new RectangleParticle(stage.width-borderWidth/2, stage.height/2, borderWidth, stage.height, 0, true);
			defaultGroup.addParticle(br);

			
			
			var cp:CircleParticle = new CircleParticle(250,50,20);
			defaultGroup.addParticle(cp);
			
			var rp:RectangleParticle = new RectangleParticle(250,300,300,50,0.3,true);
			defaultGroup.addParticle(rp);
			
			sc = new SuperCar(100, 100, 0.6);
			defaultGroup.addParticle(sc);
			
			APEngine.addGroup(defaultGroup);
			
			keyPoll = new KeyPoll(stage);
			
			stage.frameRate = 60;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(evt:Event):void {
			if(keyPoll.isDown(Keyboard.UP)) {
				sc.addForce(new org.cove.ape.Vector(30*Math.sin(sc.radian), -30*Math.cos(sc.radian)));
			}
			if(keyPoll.isDown(Keyboard.DOWN)) {
				sc.addForce(new org.cove.ape.Vector(-30*Math.sin(sc.radian), 30*Math.cos(sc.radian)));
			}
			if(keyPoll.isDown(Keyboard.LEFT)) {
				//sc.addForce(new org.cove.ape.Vector(-10, 0));
				sc.radian -= 0.05;
			}
			if(keyPoll.isDown(Keyboard.RIGHT)) {
				//sc.addForce(new org.cove.ape.Vector(10, 0));
				sc.radian += 0.05;
			}
			
			APEngine.step();
			APEngine.paint();
		}
	}
}