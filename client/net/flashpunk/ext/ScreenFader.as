package net.flashpunk.ext 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.NumTween;
	
	/**
	 * ...
	 * @author Richard Marks
	 */
	public class ScreenFader extends Entity 
	{
		private var myFader:NumTween;
		private var myBox:Image;
		
		private var myCallback:Function;
		
		public function ScreenFader(fadeTime:Number = 2, fromAlpha:Number = 1.0, toAlpha:Number = 0.0, tint:uint = 0xFF000000, callback:Function = null) 
		{
			type = "ScreenFader";
			x = 0;
			y = 0;
			myBox = Image.createRect(FP.width, FP.height, tint);
			myBox.alpha = fromAlpha;
			graphic = myBox;
			setHitbox(myBox.width, myBox.height);
			
			myFader = new NumTween(onFadeComplete, Tween.ONESHOT);
			myFader.tween(fromAlpha, toAlpha, fadeTime);
			
			myCallback = callback;
		}
		
		override public function added():void 
		{
			addTween(myFader, true);
			//trace("ScreenFader added");
			super.added();
		}
		
		override public function update():void 
		{
			try
			{
				myBox.alpha = myFader.value;
			}
			catch (e:Error)
			{
				
			}
			super.update();
		}
		
		private function onFadeComplete():void
		{
			try
			{
				FP.world.remove(this);
				//trace("ScreenFader removed");
				if (myCallback != null)
				{
					myCallback();
				}
			}
			catch (e:Error)
			{
				
			}
		}
	}
}