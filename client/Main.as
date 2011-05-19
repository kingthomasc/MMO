package 
{
	import flash.system.Security;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Thomas King
	 */
	public class Main extends Engine 
	{
		
		public function Main():void 
		{
			super(800, 600);
			Security.allowDomain("99.3.105.209");
			Security.loadPolicyFile("http://noraingames.com/crossdomain.xml");
		}
		
		override public function init():void 
		{
			super.init();
			FP.world = new MenuWorld("Enter a name.");
		}
	}
}