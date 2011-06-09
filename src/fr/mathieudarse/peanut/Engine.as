package fr.mathieudarse.peanut
{
	import com.coreyoneil.collision.CollisionGroup;
	import com.greensock.loading.LoaderMax;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.text.TextField;
	
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
		
		public function Engine(stage:Stage):void
		{
			_stage = stage;
			
			//keyPoll = new KeyPoll(_stage);
			
			_cGroup = new CollisionGroup;
			
			trace('Creating head up display...');
			_hud = new HUDisplay;
			_stage.addChild(_hud);
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