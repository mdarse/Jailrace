package fr.mathieudarse.peanut
{
	import com.greensock.loading.LoaderMax;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	public class Vehicle extends Sprite
	{
		// TODO : Move some vars into XML
		private var speed:Number = 0;
		private var speedMax:Number = 20;
		private var speedMaxReverse:Number = -3;
		private var speedAcceleration:Number = .6;
		private var speedDeceleration:Number = .5;
		private var groundFriction:Number = .95;
		
		private var steering:Number = 0;
		private var steeringMax:Number = 10;
		private var steeringAcceleration:Number = .10;
		private var steeringFriction:Number = .98;
		
		private var velocityX:Number = 0;
		private var velocityY:Number = 0;
		
		private var up:Boolean = false;
		private var down:Boolean = false;
		private var left:Boolean = false;
		private var right:Boolean = false;
		
		private var _upKey:uint;
		private var _downKey:uint;
		private var _leftKey:uint;
		private var _rightKey:uint;
		private var _fireKey:uint;
		
		private var _texture:Bitmap;
		private var _config:XML;
		
		//public var lastX:int;
		//public var lastY:int;
		//public var color:uint;
		
		public function Vehicle(config:XML):void
		{
			super();
			_config = config;
			
			graphics.beginFill(0xFF0000);
			graphics.drawRect(-1,-50,2,100);
			graphics.endFill();
			
			// Adds texture to vehicle
			var bd:BitmapData = LoaderMax.getContent(_config.texture).rawContent.bitmapData;
			_texture = new Bitmap(bd);
			_texture.x = bd.width/-2;
			_texture.y = bd.height/-2;
			addChild(_texture);
		}
		
		public function setCommandKeys(upKey:uint, downKey:uint, leftKey:uint, rightKey:uint, fireKey:uint):void
		{
			_upKey = upKey;
			_downKey = downKey;
			_leftKey = leftKey;
			_rightKey = rightKey;
			_fireKey = fireKey;
		}
		
		/*public function getCommandKeys():Object
		{
			return {up: _upKey, down: _downKey, left: _leftKey, right: _rightKey};
		}*/
		
		public function start():void
		{
			stage.addEventListener(Event.ENTER_FRAME, updatePosition);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyRelease);
		}
		
		public function stop():void
		{
			stage.removeEventListener(Event.ENTER_FRAME, updatePosition);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyRelease);
		}
		
		private function updatePosition(e:Event):void
		{
			if (up)
			{
				//check if below speedMax
				if (speed < speedMax)
				{
					//speed up
					speed += speedAcceleration;
					//check if above speedMax
					if (speed > speedMax)
					{
						//reset to speedMax
						speed = speedMax;
					}
				}
			}
			
			if (down)
			{
				//check if below speedMaxReverse
				if (speed > speedMaxReverse)
				{
					//speed up (in reverse)
					speed -= speedAcceleration;
					//check if above speedMaxReverse
					if (speed < speedMaxReverse)
					{
						//reset to speedMaxReverse
						speed = speedMaxReverse;
					}
				}
			}
			
			if (left)
			{
				//turn left
				steering -= steeringAcceleration;
				//check if above steeringMax
				if (steering > steeringMax)
				{
					//reset to steeringMax
					steering = steeringMax;
				}
			}
			
			if (right)
			{
				//turn right
				steering += steeringAcceleration;
				//check if above steeringMax
				if (steering < -steeringMax)
				{
					//reset to steeringMax
					steering = -steeringMax;
				}
			}
			
			// friction    
			speed *= groundFriction;
			
			// prevent drift
			if(speed > 0 && speed < 0.05)
			{
				speed = 0
			}
			
			// calculate velocity based on speed
			velocityX = Math.sin (this.rotation * Math.PI / 180) * speed;
			velocityY = Math.cos (this.rotation * Math.PI / 180) * -speed;
			
			// update position	
			this.x += velocityX;
			this.y += velocityY;
			
			// prevent steering drift (right)
			if(steering > 0)
			{
				// check if steering value is really low, set to 0
				if(steering < 0.05)
				{
					steering = 0;
				}		
			}
			// prevent steering drift (left)
			else if(steering < 0)
			{
				// check if steering value is really low, set to 0
				if(steering > -0.05)
				{
					steering = 0;
				}		
			}
			
			// apply steering friction
			steering = steering * steeringFriction;
			
			// make car go straight after driver stops turning
			steering -= (steering * 0.1);
			
			// rotate
			this.rotation += steering * speed;
		}
		
		private function onKeyPress(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case _upKey:
					up = true;
					break;
				
				case _downKey:
					down = true;
					break;
				
				case _leftKey:
					left = true;
					break;
				
				case _rightKey:
					right = true;
					break;
			}
			
			//e.updateAfterEvent();
		}
		
		private function onKeyRelease(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case _upKey:
					up = false;
					break;
				
				case _downKey:
					down = false;
					break;
				
				case _leftKey:
					left = false;
					break;
				
				case _rightKey:
					right = false;
					break;
			}
		}
		
		/*public function draw():void
		{
			// Size of the vehicle
			var vLenght:uint = 40;
			var vWidth:uint = 30;
			// Draw the vehicle's shape
			graphics.beginFill(0x00FF00, 0.8);
			graphics.drawRect(-vLenght/3, -vWidth/2, vLenght, vWidth);
			graphics.endFill();
			this.x += vLenght/3;
			this.y += vWidth/2;
		}*/
		
		/*public function get speed():int
		{
			return _speed;
		}
		
		public function set speed(speed:int):void
		{
			this._speed = speed;
		}*/
		
		/*public function increaseSpeed(amount:uint):void
		{
			_speed += amount;
		}
		
		public function decreaseSpeed(amount:uint):void
		{
			_speed -= amount;
		}*/
	}
}