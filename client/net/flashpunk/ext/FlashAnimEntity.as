package net.flashpunk.ext
{
	import flash.display.IBitmapDrawable;
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Mask;
	
	/**
	 * ...
	 * @author Richard Marks
	 */
	public class FlashAnimEntity extends Entity 
	{
		static public function add(drawable:IBitmapDrawable, xPos:Number = 0, yPos:Number = 0, layer:Number = 0, mask:Mask = null):FlashAnimEntity
		{
			var entity:FlashAnimEntity = new FlashAnimEntity(xPos, yPos, layer, mask);
			entity.flashGraphic = drawable;
			entity.flashMC = MovieClip(drawable);
			//entity.flashOffset.x = entity.flashMC.width * 0.5;
			//entity.flashOffset.y = entity.flashMC.height * 0.5;
			try
			{
				/*
				trace("mc pos,size",
					entity.flashMC.x,
					entity.flashMC.y,
					entity.flashMC.width,
					entity.flashMC.height);
					*/
				FP.world.add(entity);
			}
			catch (e:Error)
			{
				trace("FlashAnimEntity.add() Error -", e);
			}
			return entity;
		}
		
		public var flashMC:MovieClip;
		public var flashGraphic:IBitmapDrawable;
		public var flashScale:Number = 1;
		public var flashOffset:Point = new Point;
		public var flashAngle:Number = 0;
		public var flashAlpha:Number = 1;
		private var myColorTransform:ColorTransform = new ColorTransform(1, 1, 1, flashAlpha);
		private var myMatrix:Matrix;
		
		public function FlashAnimEntity(xPos:Number = 0, yPos:Number = 0, layer:Number = 0, mask:Mask = null)
		{
			x = xPos;
			y = yPos;
			this.layer = layer;
			this.mask = mask;
			myMatrix = FP.matrix;
		}
		
		override public function render():void 
		{
			super.render();
			
			if (!flashGraphic) { return; }
			if (flashAlpha <= 0) { return; }
			width = flashMC.width;
			height = flashMC.height;
			myColorTransform.alphaMultiplier = flashAlpha;
			
			/*
			myMatrix.identity();
			myMatrix.rotate(0.0174532925 * flashAngle);
			myMatrix.scale(flashScale, flashScale);
			myMatrix.translate(x - FP.camera.x + flashOffset.x, y - FP.camera.y + flashOffset.y);
			*/
			myMatrix.b = myMatrix.c = 0;
			myMatrix.a = flashMC.scaleX * flashScale;
			myMatrix.d = flashMC.scaleY * flashScale;
			myMatrix.tx = -flashOffset.x * myMatrix.a;
			myMatrix.ty = -flashOffset.y * myMatrix.d;
			if (flashAngle != 0)
			{
				myMatrix.rotate(0.0174532925 * flashAngle);
			}
			myMatrix.tx += (flashOffset.x + (x - FP.camera.x));
			myMatrix.ty += (flashOffset.y + (y - FP.camera.y));
			
			//trace("matrix=",myMatrix);
			FP.buffer.draw(flashGraphic, myMatrix, myColorTransform);
		}
	}

}