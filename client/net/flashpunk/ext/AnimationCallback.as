package net.flashpunk.ext 
{
	/**
	 * ...
	 * @author Thomas King
	 */
	public class AnimationCallback 
	{
		public function AnimationCallback(callback:Function, frame:int, save:Boolean) 
		{
			_callback = callback;
			_frame = frame;
			_save = save;
			_dirty = false;
		}
		
		public function update(sequenceFrame:int):void
		{
			// no callback - this should never happen
			if (_callback == null) { _dirty = true; return; }
			
			// not the right frame for the callback
			if (sequenceFrame != _frame) { return; }
			
			// call the callback function
			_callback();
			
			// preserve callback if save flag is true
			_dirty = (_save) ? false : true;
		}
		
		public function get callback():Function { return _callback; }
		
		public function get frame():int { return _frame; }
		
		public function get save():Boolean { return _save; }
		
		public function get dirty():Boolean { return _dirty; }
		
		/** private*/ private var _callback:Function;
		/** private*/ private var _frame:int;
		/** private*/ private var _save:Boolean;
		/** private*/ private var _dirty:Boolean;
	}

}