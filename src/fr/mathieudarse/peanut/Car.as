package fr.mathieudarse.peanut
{
	public class Car extends Vehicle
	{
		private var maxForwardSpeed:Number = 40;
		private var maxRewindSpeed:Number = -20;
		
		public function Car():void
		{
			super();
		}
		
		public override function increaseSpeed(amount:uint):void
		{
			if(speed+amount <= maxForwardSpeed) {
				_speed += amount;
			}
			else {
				_speed = maxForwardSpeed;
			}
		}
		
		public override function decreaseSpeed(amount:uint):void
		{
			if(speed-amount >= maxRewindSpeed) {
				_speed -= amount;
			}
			else {
				_speed = maxRewindSpeed;
			}
		}
	}
}