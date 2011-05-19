package fr.mathieudarse.peanut
{
	import flash.display.Sprite;
	
	public class Vehicle extends Sprite
	{
		protected var _speed:Number = 0;
		
		public var leftKey:uint;
		public var rightKey:uint;
		public var upKey:uint;
		public var downKey:uint;
		public var lastX:int;
		public var lastY:int;
		public var color:uint;
		
		public function Vehicle():void
		{
			super();
			//draw();
		}
		
		public function draw():void
		{
			// Size of the vehicle
			var vLenght:uint = 40;
			var vWidth:uint = 30;
			// Draw the vehicle's shape
			graphics.beginFill(color, 0.8);
			graphics.drawRect(-vLenght/3, -vWidth/2, vLenght, vWidth);
			graphics.endFill();
			this.x += vLenght/3;
			this.y += vWidth/2;
		}
		
		public function get speed():int
		{
			return _speed;
		}
		
		public function set speed(speed:int):void
		{
			this._speed = speed;
		}
		
		public function increaseSpeed(amount:uint):void
		{
			_speed += amount;
		}
		
		public function decreaseSpeed(amount:uint):void
		{
			_speed -= amount;
		}
		
		public function stop():void
		{
			_speed = 0;
		}
	}
}