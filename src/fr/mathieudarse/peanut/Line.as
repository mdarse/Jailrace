package fr.mathieudarse.peanut
{
	import flash.display.Shape;
	
	public class Line extends Shape
	{
		private var _index:uint;
		
		public function Line(fromX:uint, fromY:uint, toX:uint, toY:uint, index:uint = 0)
		{
			super();
			graphics.moveTo(fromX, fromY);
			graphics.lineStyle(0/*, 0xFF0000*/);
			graphics.lineTo(toX, toY);
			_index = index;
		}
		
		public function get index():uint {
			return _index;
		}
	}
}