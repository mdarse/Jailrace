package fr.mathieudarse.peanut
{
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.display.ContentDisplay;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	public class Track extends Sprite
	{
		//private var _texture:ContentDisplay;
		private var _texture:Bitmap;
		private var _areas:Bitmap;
		
		public function Track(track:XML)
		{
			super();
			
			//_texture = LoaderMax.getContent(track.texture);
			_texture = LoaderMax.getContent(track.texture).rawContent;
			addChild(_texture);
			_areas = LoaderMax.getContent(track.texture).rawContent;
		}
	}
}