package fr.mathieudarse.peanut
{
	import com.coreyoneil.collision.CollisionGroup;
	import com.greensock.loading.LoaderMax;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	import uk.co.bigroom.input.KeyPoll;
	
	public class Engine
	{
		//private var keyPoll:KeyPoll;
		//private var collisionGroup:CollisionGroup;
		private const PI_OVER_ONE_HEIGHTY:Number = Math.PI/180;
		
		private var _stage:Stage;
		private var _currentTrack:Track;
		private var _vehicles:Array = new Array;
		private var _cGroup:CollisionGroup;
		private var _hud:HUDisplay;
		
		private var _collides:TextField;
		private var _fpsTrkField:TextField;
		private var _fpsTrkMax:int = 30;
		private var _fpsTrkCurrent:int = 0;
		private var _fpsTrkPrevTime:int;
		
		public function Engine(stage:Stage):void
		{
			_stage = stage;
			
			//keyPoll = new KeyPoll(_stage);
			
			// FPS Tracker
			_fpsTrkField = new TextField;
			_fpsTrkField.defaultTextFormat = new TextFormat('Verdana', 12, 0xFFFF00);
			_fpsTrkField.y = 520;
			_stage.addChild(_fpsTrkField);
			// End FPS
			
			_collides = new TextField();
			_collides.defaultTextFormat = new TextFormat('Verdana', 10, 0x00ff00);
			_collides.x = 110;
			_collides.width = 800;
			_collides.height = 50;
			_stage.addChild(_collides);
			
			_cGroup = new CollisionGroup;
			_cGroup.returnAngleType = 'DEGREES';
			
		}
		
		public function addVehicle(vehicle:Vehicle):void
		{
			trace('Adding vehicle to engine...');
			_vehicles.push(vehicle);
			initVehiclePosition(vehicle);
			_stage.addChild(vehicle);
			
			// Add vehicle to collision group
			_cGroup.addItem(vehicle);
		}
		
		private function initVehiclePosition(vehicle:Vehicle):void
		{
			// Retrive start positions from track
			var i:int = _vehicles.indexOf(vehicle);
			var vp:XML = _currentTrack.getVehiclePosition(i);
			
			// Setting positions
			trace('Moving vehicle with index '+vp.@index+' to ('+vp.@x+', '+vp.@y+', r'+vp.@rotation+')...');
			vehicle.x = vp.@x;
			vehicle.y = vp.@y;
			vehicle.rotation = vp.@rotation
		}
		
		public function loadTrack(config:XML):void
		{
			trace('Loading a new track...');
			if(_currentTrack != null) {
				_cGroup.removeItem(_currentTrack.areas);
			}
			_currentTrack = new Track(config);
			_cGroup.addItem(_currentTrack.areas);
			
			_stage.addChildAt(_currentTrack, 0);
		}
		
		public function start():void
		{
			trace('Starting engine...');
			_stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			for each(var vehicle:Vehicle in _vehicles)
			{
				vehicle.start();
			}
		}
		
		public function stop():void
		{
			trace('Stopping engine...');
			_stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			for each(var vehicle:Vehicle in _vehicles)
			{
				vehicle.stop();
			}
		}
		
		private function onEnterFrame(event:Event):void
		{
			// FPS Tracker
			_fpsTrkCurrent++;
			if(_fpsTrkCurrent == _fpsTrkMax) {
				var currentTime:int = getTimer();
				_fpsTrkField.text = (1000*_fpsTrkMax/(currentTime-_fpsTrkPrevTime)).toFixed(2)+' FPS';
				_fpsTrkCurrent = 0;
				_fpsTrkPrevTime = currentTime;
			}
			// End FPS
			
			var collisions:Array = _cGroup.checkCollisions();
			var text:String = "";
			for each(var c:Object in collisions) {
				text += 'Collision between '+c.object1+' and '+c.object2+' ('+c.angle+")\n";
				
				if(getQualifiedClassName(c.object1) == 'fr.mathieudarse.peanut::Vehicle') {
					c.object1.bounce();
				}
				if(getQualifiedClassName(c.object2) == 'fr.mathieudarse.peanut::Vehicle') {
					c.object2.bounce();
				}
				
			}
			_collides.text = text;
			
			// Updating speeds on HUD
			//_hud.setSpeed(_vehicles[0].speed, _vehicles[1].speed);
		}
		
		/*private function isColliding():Boolean
		{
			var collisions:Array = collisionGroup.checkCollisions();
			_hud.collides.text = "No collidings";
			for each (var collision:Object in collisions) {
				_hud.collides.text = collision.object1.toString() + " colliding with " + collision.object2.toString() + "\n";
			}
			if(collisions.length >= 1) {
				return true;
			}
			else {
				return false;
			}
		}*/
		
		/*private function updateSpeed(vehicle:Vehicle):void
		{
			// Speed variations
			if(keyPoll.isDown(vehicle.upKey)) {
				vehicle.increaseSpeed(1);
			}
			if(keyPoll.isDown(vehicle.downKey)) {
				vehicle.decreaseSpeed(1);
			}
		}
		
		private function updateDirection(vehicle:Vehicle):void
		{
			// Makes vehicles turn
			if(keyPoll.isDown(vehicle.leftKey)) {
				vehicle.rotation -= 10;
			}
			if(keyPoll.isDown(vehicle.rightKey)) {
				vehicle.rotation += 10;
			}
		}
		
		private function updatePosition(vehicle:Vehicle):void
		{
			// Update to new positions
			vehicle.x += vehicle.speed*speedCoef*Math.cos(vehicle.rotation*radianCoef);
			vehicle.y += vehicle.speed*speedCoef*Math.sin(vehicle.rotation*radianCoef);
			
			// Prevent vehicle from going out of screen
			if(vehicle.x > _stage.stageWidth) {
				vehicle.x -= _stage.stageWidth;
			}
			if(vehicle.x < 0) {
				vehicle.x += _stage.stageWidth;
			}
			if(vehicle.y > _stage.stageHeight) {
				vehicle.y -= _stage.stageHeight;
			}
			if(vehicle.y < 0) {
				vehicle.y += _stage.stageHeight;
			}
			trace(vehicle.x+'x'+vehicle.y);
		}
		
		private function handleCollision(vehicle:Vehicle):void
		{
			vehicle.speed = vehicle.speed/2;
		}*/
	}
}