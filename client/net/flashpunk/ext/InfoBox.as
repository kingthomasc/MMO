package net.flashpunk.ext
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	
	/**
	 * ...
	 * @author Richard Marks
	 */
	public class InfoBox extends Entity 
	{
		static public var alpha:Number = 1.0;
		static public var backgroundColor:uint = 0xFF7E8D72;
		static public var foregroundColor:uint = 0xFF2E3227;//0xFF545C4B;
		static public var borderColor:uint = 0xFFA3AD9A;
		static public var borderWidth:int = 4;
		
		private var myLines:Vector.<String>;
		private var myBackground:Image;
		private var myGfx:Graphiclist;
		
		public function InfoBox(xPos:Number = 0, yPos:Number = 0, lines:Vector.<String> = null) 
		{
			type = "InfoBox";
			x = xPos;
			y = yPos;
			layer = -99;
			
			if (lines == null)
			{
				throw new Error("lines cannot be null");
			}
			
			// determine the dimensions of the box
			var lineLength:int = 0;
			var longestLineIndex:int = 0;
			var lineCount:int = lines.length;
			for (var i:int = 0; i < lineCount; i++)
			{
				if (lines[i].length > lines[longestLineIndex].length)
				{
					longestLineIndex = i;
				}
			}
			const padding:int = 4;
			const padding2:int = padding * 2;
			width = (borderWidth*2) + padding2 + new Text(lines[longestLineIndex]).width;
			height = (borderWidth*2) + ((padding2 + Text.size) * lineCount) + padding2;
			
			// create the box
			//var boxBmp:BitmapData = new BitmapData(width, height, true, InfoBox.borderColor);
			//boxBmp.fillRect(new Rectangle(2, 2, width - 4, height - 4), InfoBox.backgroundColor);
			var boxBmp:BitmapData = makeRoundBox(width, height);
			myBackground = new Image(boxBmp);
			
			myBackground.alpha = InfoBox.alpha;
			
			myGfx = new Graphiclist(myBackground);
			
			// add the text
			var cursorY:Number = padding2;
			for each(var line:String in lines)
			{
				if (line.length > 0)
				{
					var t:Text = new Text(line, padding2, cursorY);
					t.color = InfoBox.foregroundColor;
					t.alpha = InfoBox.alpha;
					myGfx.add(t);
					cursorY += (t.height + padding);
				}
				else
				{
					cursorY += (padding + Text.size);
				}
			}
			
			graphic = myGfx;
			
			active = false;
		}
		
		static private function makeRoundBox(width:int, height:int):BitmapData
		{
			var bWidth:int = InfoBox.borderWidth;
			var bWidth2:int = bWidth * 2;
			var bWidthHalf:int = int(bWidth * 0.5);
			
			var inside:Rectangle = new Rectangle(bWidth, bWidth, width - bWidth2, height - bWidth2);
			
			var box:BitmapData = new BitmapData(width, height, true, InfoBox.borderColor);
			box.fillRect(inside, InfoBox.backgroundColor);
			var i:int;
			const tc:uint = 0x00000000;
			const bc:uint = InfoBox.borderColor;
			for (i = 0; i < bWidth; i++)
			{
				box.setPixel32(i, 0, tc);
				box.setPixel32(0, i, tc);
				box.setPixel32(0, height - i, tc);
				box.setPixel32(i, height - 1, tc);
				box.setPixel32(width - i, 0, tc);
				box.setPixel32(width - 1, i, tc);
				box.setPixel32(width - 1, height - i, tc);
				box.setPixel32(width - i, height - 1, tc);
				
				// inner border
				box.setPixel32(bWidth + i, bWidth, bc);
				box.setPixel32(bWidth, bWidth + i, bc);
				box.setPixel32(bWidth, height - (bWidth + i), bc);
				box.setPixel32(bWidth + i, height - (bWidth + 1), bc);
				box.setPixel32(width - (bWidth + i), bWidth, bc);
				box.setPixel32(width - (bWidth + 1), bWidth + i, bc);
				box.setPixel32(width - (bWidth + 1), height - (bWidth + i), bc);
				box.setPixel32(width - (bWidth + i), height - (bWidth + 1), bc);
				
				if (i > bWidthHalf)
				{
					continue;
				}
				
				var ii:int = 1 + i;
				box.setPixel32(ii, 1, tc);
				box.setPixel32(1, ii, tc);
				box.setPixel32(1, height - ii, tc);
				box.setPixel32(ii, height - 2, tc);
				box.setPixel32(width - ii, 1, tc);
				box.setPixel32(width - 2, ii, tc);
				box.setPixel32(width - 2, height - ii, tc);
				box.setPixel32(width - ii, height - 2, tc);
				
				// inner border
				box.setPixel32(bWidth + ii, bWidth + 1, bc);
				box.setPixel32(bWidth + 1, bWidth + ii, bc);
				box.setPixel32(bWidth + 1, height - (bWidth + ii), bc);
				box.setPixel32(bWidth + ii, height - (bWidth + 2), bc);
				box.setPixel32(width - (bWidth + ii), bWidth + 1, bc);
				box.setPixel32(width - (bWidth + 2), (bWidth + ii), bc);
				box.setPixel32(width - (bWidth + 2), height - (bWidth + ii), bc);
				box.setPixel32(width - (bWidth + ii), height - (bWidth + 2), bc);
			}
			
			return box;
		}
	}
}