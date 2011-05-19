package  
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Thomas King
	 */
	public class Player extends Entity 
	{
		[Embed(source = 'images/player.png')]
		public static const PLAYER:Class;
		
		public var name:String;
		public var id:int;
		public var health:Number;
		public var velocity:Point = new Point;
		
		public function Player(name:String, x:int, y:int, id:int) 
		{
			this.name = name;
			this.x = x;
			this.y = y;
			this.id = id;
			
			graphic = new Image(PLAYER);
		}
	}
}