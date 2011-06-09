package fr.mathieudarse.peanut
{
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.display.ContentDisplay;
	
	import flash.display.Bitmap;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	public class Track extends Sprite
	{
		//private var _texture:ContentDisplay;
		private var _texture:Bitmap;
		private var _areas:Bitmap;
		private var _finish:Line;
		private var _checkpoints:Array = new Array;
		private var _config:XML;
		
		public function Track(config:XML)
		{
			super();
			_config = config;
			
			_texture = LoaderMax.getContent(_config.texture).rawContent;
			addChild(_texture);
			_areas = LoaderMax.getContent(_config.areas).rawContent;
			//addChild(_areas);
			
			
			// Starting/finish line
			var sc:XML = _config.positions.finish[0];
			_finish = new Line(sc.@fromX, sc.@fromY, sc.@toX, sc.@toY);
			addChild(_finish);
			
			// Checkpoints
			for each(var cc:XML in _config.positions.checkpoint) {
				var checkpoint:Line = new Line(cc.@fromX, cc.@fromY, cc.@toX, cc.@toY, cc.@index);
				_checkpoints.push(checkpoint);
				addChild(checkpoint);
			}
		}
		
		public function getVehiclePosition(index:uint):XML
		{
			return _config.positions.vehicle[index];
		}
		
		public function get areas():Bitmap {
			return _areas;
		}
		
		public function get finish():Line {
			return _finish;
		}
		
		public function get checkpoints():Array {
			return _checkpoints;
		}
	}
}