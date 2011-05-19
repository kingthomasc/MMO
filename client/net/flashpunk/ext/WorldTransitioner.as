package net.flashpunk.ext 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.Alarm;
	import net.flashpunk.tweens.misc.NumTween;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	/**
	 * ...
	 * @author Richard Marks
	 */
	public class WorldTransitioner extends Entity 
	{
		// new static implementation
		
		static public function FadeIn(fadeInTime:Number = 2, tint:uint = 0xFF000000):void 
		{
			try
			{
				FP.world.add(new ScreenFader(fadeInTime, 1.0, 0.0, tint));
			}
			catch (e:Error)
			{
			}
		}
		
		static public function FadeOut(fadeOutTime:Number = 2, tint:uint = 0xFF000000):void 
		{
			try
			{
				FP.world.add(new ScreenFader(fadeOutTime, 0.0, 1.0, tint));
			}
			catch (e:Error)
			{
			}
		}
		
		static public function FadeOutAndChange(destWorld:Class, fadeOutTime:Number = 2, tint:uint = 0xFF000000):void 
		{
			try
			{
				FP.world.add(new ScreenFader(fadeOutTime, 0.0, 1.0, tint, function():void
				{
					FP.world = new destWorld;
				}));
			}
			catch (e:Error)
			{
			}
		}
		
		static public function RegisterTransition(destWorld:Class, fadeInTime:Number = 2, fadeOutTime:Number = 2, idleTime:Number = 3, fromTint:uint = 0xFF000000, toTint:uint = 0xFF000000):void
		{
			try
			{
				FP.world.add(new WorldTransitioner(destWorld, fadeInTime, fadeOutTime, idleTime, fromTint, toTint));
			}
			catch (e:Error)
			{
				
			}
		}
		
		static public function ChangeNow(destWorld:Class):void
		{
			try
			{
				FP.world = new destWorld;
			}
			catch (e:Error)
			{
				
			}
		}
		
		private var myChangeAlarm:Alarm;
		private var myDestWorld:Class; 
		private var myFadeInTime:Number;
		private var myFadeOutTime:Number;
		private var myIdleTime:Number;
		private var myFromTint:uint;
		private var myToTint:uint;
		
		public function WorldTransitioner(destWorld:Class, fadeInTime:Number = 2, fadeOutTime:Number = 2, idleTime:Number = 3, fromTint:uint = 0xFF000000, toTint:uint = 0xFF000000) 
		{
			type = "WorldTransitioner";
			
			myDestWorld = destWorld;
			myFadeInTime = fadeInTime;
			myFadeOutTime = fadeOutTime;
			myIdleTime = idleTime;
			myFromTint = fromTint;
			myToTint = toTint;
			myChangeAlarm = new Alarm(idleTime, onIdleComplete, Tween.ONESHOT);
		}
		
		override public function added():void 
		{
			WorldTransitioner.FadeIn(myFadeInTime, myFromTint);
			addTween(myChangeAlarm, true);
			super.added();
		}
		
		override public function update():void 
		{
			if (Input.mousePressed || Input.pressed(Key.ANY))
			{
				try
				{
					//trace("alarm interrupted");
					removeTween(myChangeAlarm);
				}
				catch (e:Error)
				{
					
				}
				onIdleComplete();
			}
			super.update();
		}
		
		private function onIdleComplete():void
		{
			WorldTransitioner.FadeOutAndChange(myDestWorld, myFadeOutTime, myToTint);
			try
			{
				FP.world.remove(this);
				//trace("idle complete - WorldTransitioner removed");
			}
			catch (e:Error)
			{
				
			}
		}
	}
}