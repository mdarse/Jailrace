package fr.mathieudarse.peanut
{
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	
	public class Bullet extends Shape
	{
		private const PI_OVER_ONE_HEIGHTY:Number = Math.PI/180;
		private var _stage:Stage;
		private var _velocityX:Number;
		private var _velocityY:Number;
		private var _speed:Number;
		
		public function Bullet(stage:Stage, x:Number, y:Number, rotation:Number, speed:Number)
		{
			super();
			_stage = stage;
			this.x = x;
			this.y = y;
			this.rotation = rotation;
			_speed = speed;
			
			// calculate velocity based on speed
			_velocityX = Math.sin (this.rotation * PI_OVER_ONE_HEIGHTY) * _speed;
			_velocityY = Math.cos (this.rotation * PI_OVER_ONE_HEIGHTY) * -_speed;
			
			graphics.beginFill(0x000000);
			graphics.drawRect(-1, -1, 2, 2);
			graphics.endFill();
			
			_stage.addChild(this);
			_stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			// update position
			this.x += _velocityX;
			this.y += _velocityY;
		}
		
		private function onEnterFrame(e:Event):void
		{
			// update position
			this.x += _velocityX;
			this.y += _velocityY;
		}
	}
}