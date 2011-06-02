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
		private var keyPoll:KeyPoll;
		private var collisionGroup:CollisionGroup;
		private var vehicles:Array = new Array;
		private var radianCoef:Number = Math.PI/180;
		private var speedCoef:Number = 0.5;
		
		private var _stage:Stage;
		private var _currentTrack:Track;
		private var _hud:HUDisplay;
		
		public function Engine(stage:Stage):void
		{
			_stage = stage;
			collisionGroup = new CollisionGroup;
		}
		
		public function addVehicle(vehicle:Vehicle):void
		{
			vehicles.push(vehicle);
			collisionGroup.addItem(vehicle);
		}
		
		public function loadTrack(config:XML):void
		{
			trace('Loading a new track...');
			var _currentTrack:Track = new Track(config);
			_stage.addChildAt(_currentTrack, 0);
			
		}
		
		public function start():void
		{
			keyPoll = new KeyPoll(_stage);
			
			trace('Creating head up display...');
			_hud = new HUDisplay;
			_stage.addChild(_hud);
			
			_stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function stop():void
		{
			_stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(event:Event):void
		{
			for each (var vehicle:Vehicle in vehicles) {
				updateSpeed(vehicle);
				/*if(isColliding()) {
					handleCollision(vehicle);
				}*/
				updateDirection(vehicle);
				if(vehicle.speed != 0) {
					
					// Kinetic
					if(keyPoll.isUp(vehicle.upKey) && vehicle.speed > 0) {
						vehicle.decreaseSpeed(1);
						//vehicle.stop();
					}
					if(keyPoll.isUp(vehicle.downKey) && vehicle.speed < 0) {
						vehicle.increaseSpeed(1);
						//vehicle.stop();
					}
					updatePosition(vehicle);
				}
			}
			// Updating speeds on HUD
			_hud.setSpeed(vehicles[0].speed, vehicles[1].speed);
		}
		
		private function isColliding():Boolean
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
		}
		
		private function updateSpeed(vehicle:Vehicle):void
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
		}
		
		private function handleCollision(vehicle:Vehicle):void
		{
			vehicle.speed = vehicle.speed/2;
		}
	}
}