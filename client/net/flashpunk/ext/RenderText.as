package net.flashpunk.ext 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	/**
	 * ...
	 * @author Richard Marks
	 */
	public class RenderText 
	{
		static public var font:String = "default";
		static public var size:uint = 8;
		static public var color:uint = 0xFFFFFFFF;
		/**
		 * streamlined method to render text to a BitmapData surface without going through dealing with the Flash components directly.
		 * text uses the RenderText.font, RenderText.color and RenderText.size information for creation
		 * @param	text - string of text to render
		 * @param	target - BitmapData to render the text on
		 * @param	point - coordinate at which to render the text
		 * @param	camera - offset of the camera - if null FP.camera is used
		 */
		static public function toBitmap(text:String, target:BitmapData, point:Point, camera:Point = null):void
		{
			if (camera == null) { camera = FP.camera; }
			
			try
			{
				var oldFont:String = String(Text.font);
				var oldSize:uint = uint(Text.size);
				Text.font = RenderText.font;
				Text.size = RenderText.size;
				var t:Text = new Text(text);
				t.color = RenderText.color;
				t.x = point.x;
				t.y = point.y;
				t.renderToBitmap(target, FP.zero, camera);
				Text.font = oldFont;
				Text.size = oldSize;
			}
			catch (err:Error)
			{
				
			}
		}
	}

}