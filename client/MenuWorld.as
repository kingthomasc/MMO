package  
{
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.World;
	
	/**
	 * ...
	 * @author Thomas King
	 */
	public class MenuWorld extends World 
	{
		private var nameField:TextField;
		private var text:Text;
		
		public function MenuWorld(status:String) 
		{
			nameField = new TextField;
			nameField.x = 200;
			nameField.y = 50;
			nameField.height = 18;
			nameField.background = true;
			nameField.multiline = false;
			nameField.type = TextFieldType.INPUT;
			FP.stage.addChild(nameField);
			nameField.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			
			text = new Text(status);
			addGraphic(text);
		}
		
		public function keyPressed(e:KeyboardEvent):void 
		{
			if (e.keyCode == 13 && nameField.text.length > 0) {
				FP.world = new EntityManager(nameField.text);
			}
		}
		
		override public function end():void 
		{
			super.end();
			FP.stage.removeChild(nameField);
		}
	}
}