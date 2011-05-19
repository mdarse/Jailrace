package fr.mathieudarse.peanut
{
	import com.coreyoneil.collision.CollisionGroup;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.text.TextField;
	
	import uk.co.bigroom.input.KeyPoll;
	
	public class Engine
	{
		private var keyPoll:KeyPoll;
		private var collisionGroup:CollisionGroup;
		private var stage:Stage;
		private var vehicles:Array = new Array;
		private var radianCoef:Number = Math.PI/180;
		private var speedCoef:Number = 0.5;
		
		public var hud:HUDisplay;
		
		public function Engine(stage:Stage):void
		{
			this.stage = stage
			collisionGroup = new CollisionGroup;
		}
		
		public function addVehicle(vehicle:Vehicle):void
		{
			vehicles.push(vehicle);
			collisionGroup.addItem(vehicle);
		}
		
		public function start():void
		{
			keyPoll = new KeyPoll(stage);
			stage.addEventListener(Event.ENTER_FRAME, loop);
		}
		
		public function stop():void
		{
			stage.removeEventListener(Event.ENTER_FRAME, loop);
		}
		
		private function loop(event:Event):void
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
			// Updating speed on HUD
			hud.textField.text = "V1 speed: "+String(vehicles[0].speed)+"\nV2 speed: "+String(vehicles[1].speed);
		}
		
		private function isColliding():Boolean
		{
			var collisions:Array = collisionGroup.checkCollisions();
			hud.collides.text = "No collidings";
			for each (var collision:Object in collisions) {
				hud.collides.text = collision.object1.toString() + " colliding with " + collision.object2.toString() + "\n";
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
		}
		
		private function handleCollision(vehicle:Vehicle):void
		{
			vehicle.speed = vehicle.speed/2;
		}
	}
}