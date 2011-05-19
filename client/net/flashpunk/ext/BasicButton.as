package net.flashpunk.ext 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	
	/**
	 * ...
	 * @author Richard Marks
	 */
	public class BasicButton extends Entity 
	{
		private var onClick:Function;
		private var myText:Text;
		private var myGfx:Graphiclist;
		
		public function BasicButton(caption:String, clickHandler:Function = null, xPos:Number = 0, yPos:Number = 0, width:int = 0, height:int = 0, bgColor:uint = 0xFF007400, fgColor:uint = 0xFFFFFFFF) 
		{
			type = "BasicButton";
			x = xPos;
			y = yPos;
			
			myText = new Text(caption);
			myText.color = fgColor;
			
			if (!width) { width = myText.width + 8; }
			if (!height) { height = myText.height + 8; }
			
			width = Math.max(width, myText.width);
			height = Math.max(height, myText.height);
			
			myText.x = int((width - myText.width) * 0.5);
			myText.y = int((height - myText.height) * 0.5);
			
			myGfx = new Graphiclist(Image.createRect(width, height, bgColor), myText);
			myGfx.x -= width * 0.5;
			myGfx.y -= height * 0.5;
			
			graphic = myGfx;
			setHitbox(width, height);
			centerOrigin();
			
			onClick = clickHandler;
		}
		
		public function disable():void 
		{
			if (!active) { return; }
			active = false;
			var darken:Image = Image.createRect(width, height, 0xFF797979);
			darken.alpha = 0.8;
			myGfx.add(darken);
		}
		
		public function enable():void 
		{
			if (active) { return; }
			active = true;
			myGfx.removeAt(2);
		}
		
		override public function update():void 
		{
			if (onClick == null)
			{
				return;
			}
			
			if (!Input.mousePressed)
			{
				return;
			}
			
			if (!collidePoint(x, y, FP.screen.mouseX, FP.screen.mouseY))
			{
				return;
			}
			
			onClick();
			
			super.update();
		}
	}
}