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
		
		public function Track(track:XML)
		{
			super();
			
			//_texture = LoaderMax.getContent(track.texture);
			_texture = LoaderMax.getContent(track.texture).rawContent;
			addChild(_texture);
			_areas = LoaderMax.getContent(track.areas).rawContent;
			addChild(_areas);
			
			// Creates specific delimiters;
			// Starting/finish line
			var sc:XML = track.positions.finish[0];
			_finish = new Line(sc.@fromX, sc.@fromY, sc.@toX, sc.@toY);
			addChild(_finish);
			// Checkpoints
			for each(var cc:XML in track.positions.checkpoint) {
				var checkpoint:Line = new Line(cc.@fromX, cc.@fromY, cc.@toX, cc.@toY, cc.@index);
				_checkpoints.push(checkpoint);
				addChild(checkpoint);
			}
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