package fr.mathieudarse.peanut
{
	import com.greensock.loading.LoaderMax;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	public class Vehicle extends Sprite
	{
		private const PI_OVER_ONE_HEIGHTY:Number = Math.PI / 180;
		
		// TODO : Move some vars into XML
		private var _speed:Number = 0;
		private var _speedMax:Number = 8;
		private var _speedMaxReverse:Number = -2;
		private var _speedAcceleration:Number = .5;
		private var _speedDeceleration:Number = .4;
		private var _groundFriction:Number = .95;
		
		private var _steering:Number = 0;
		private var _steeringMax:Number = 2;
		private var _steeringAcceleration:Number = .15;
		private var _steeringFriction:Number = .98;
		
		private var _velocityX:Number = 0;
		private var _velocityY:Number = 0;
		
		private var _up:Boolean = false;
		private var _down:Boolean = false;
		private var _left:Boolean = false;
		private var _right:Boolean = false;
		
		private var _fire:Boolean = false;
		
		private var _upKey:uint;
		private var _downKey:uint;
		private var _leftKey:uint;
		private var _rightKey:uint;
		private var _fireKey:uint;
		
		private var _texture:Bitmap;
		private var _stage:Stage;
		private var _config:XML;
		
		public var inCollision:Boolean;
		//public var lastX:int;
		//public var lastY:int;
		//public var color:uint;
		
		public function Vehicle(stage:Stage, config:XML):void
		{
			super();
			_stage = stage;
			_config = config;
			
			/*graphics.beginFill(0xFF0000);
			graphics.drawRect(-1,-50,2,100);
			graphics.endFill();*/
			
			// Adds texture to vehicle
			var bd:BitmapData = LoaderMax.getContent(_config.texture).rawContent.bitmapData;
			_texture = new Bitmap(bd);
			_texture.x = bd.width/-2;
			_texture.y = bd.height/-2;
			//_texture.scaleX = 0.5;
			//_texture.scaleY = 0.5;
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
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyRelease);
		}
		
		public function stop():void
		{
			stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyRelease);
			
			_speed = 0;
		}
		
		private function onEnterFrame(e:Event):void
		{
			if (_up)
			{
				//check if below speedMax
				if (_speed < _speedMax)
				{
					//speed up
					_speed += _speedAcceleration;
					//check if above speedMax
					if (_speed > _speedMax)
					{
						//reset to speedMax
						_speed = _speedMax;
					}
				}
			}
			
			if (_down)
			{
				//check if below speedMaxReverse
				if (_speed > _speedMaxReverse)
				{
					//speed up (in reverse)
					_speed -= _speedAcceleration;
					//check if above speedMaxReverse
					if (_speed < _speedMaxReverse)
					{
						//reset to speedMaxReverse
						_speed = _speedMaxReverse;
					}
				}
			}
			
			if (_left)
			{
				//turn left
				_steering -= _steeringAcceleration;
				//check if above steeringMax
				if (_steering > _steeringMax)
				{
					//reset to steeringMax
					_steering = _steeringMax;
				}
			}
			
			if (_right)
			{
				//turn right
				_steering += _steeringAcceleration;
				//check if above steeringMax
				if (_steering < -_steeringMax)
				{
					//reset to steeringMax
					_steering = -_steeringMax;
				}
			}
			
			// friction    
			_speed *= _groundFriction;
			
			// prevent drift
			if(_speed > 0 && _speed < 0.05)
			{
				_speed = 0
			}
			if(_speed < 0 && _speed > -0.05)
			{
				_speed = 0
			}
			
			// calculate velocity based on speed
			_velocityX = Math.sin (this.rotation * PI_OVER_ONE_HEIGHTY) * _speed;
			_velocityY = Math.cos (this.rotation * PI_OVER_ONE_HEIGHTY) * -_speed;
			
			// update position	
			this.x += _velocityX;
			this.y += _velocityY;
			
			// prevent steering drift (right)
			if(_steering > 0)
			{
				// check if steering value is really low, set to 0
				if(_steering < 0.05)
				{
					_steering = 0;
				}		
			}
			// prevent steering drift (left)
			else if(_steering < 0)
			{
				// check if steering value is really low, set to 0
				if(_steering > -0.05)
				{
					_steering = 0;
				}		
			}
			
			// apply steering friction
			_steering = _steering * _steeringFriction;
			
			// make car go straight after driver stops turning
			_steering -= (_steering * 0.1);
			
			// rotate
			this.rotation += _steering * _speed;
			
			////////////////////
			// Fire!
			if(_fire)
			{
				var bullet:Bullet = new Bullet(_stage, this.x, this.y, this.rotation, 20);
			}
			// End fire
		}
		
		public function bounce(weakening:Number = .5):void
		{
			_speed *= -weakening;
		}
		
		private function onKeyPress(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case _upKey:
					_up = true;
					break;
				
				case _downKey:
					_down = true;
					break;
				
				case _leftKey:
					_left = true;
					break;
				
				case _rightKey:
					_right = true;
					break;
				
				case _fireKey:
					_fire = true;
					break;
			}
			
			//e.updateAfterEvent();
		}
		
		private function onKeyRelease(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case _upKey:
					_up = false;
					break;
				
				case _downKey:
					_down = false;
					break;
				
				case _leftKey:
					_left = false;
					break;
				
				case _rightKey:
					_right = false;
					break;
				
				case _fireKey:
					_fire = false;
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
		
		public function get speed():Number
		{
			return _speed;
		}
		
		/*public function set speed(speed:int):void
		{
			_speed = speed;
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