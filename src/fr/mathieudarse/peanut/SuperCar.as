package fr.mathieudarse.peanut
{
	import org.cove.ape.RectangleParticle;
	
	public class SuperCar extends RectangleParticle
	{
		public function SuperCar(x:Number, y:Number, rotation:Number=0)
		{
			super(x, y, 20, 30, rotation, false, 10, 0, 0);
		}
	}
}