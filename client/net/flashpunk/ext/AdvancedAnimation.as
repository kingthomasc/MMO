package net.flashpunk.ext
{
	import net.flashpunk.graphics.*;
	/**
	 * ...
	 * @author Thomas King, Richard Marks
	 */
	public class AdvancedAnimation extends Spritemap
	{
		/**
		 * Constructor.
		 * @param	source			Source image.
		 * @param	frameWidth		Frame width.
		 * @param	frameHeight		Frame height.
		 * @param	callback		Optional callback function for animation end.
		 */
		public function AdvancedAnimation(source:*, frameWidth:uint = 0, frameHeight:uint = 0, callback:Function = null) 
		{
			super(source, frameWidth, frameHeight, callback);
			_updater = simpleUpdate;
		}
		
		/** @private Updates the animation. */
		override public function update():void 
		{
			if (_sequence === null) 
			{
				super.update();
				return;
			}
			
			_updater();
		}
		
		private function simpleUpdate():void
		{
			updateSequence();
			playAnim(_sequence.animations[_sequenceIndex]);
			super.update();
		}
		
		private function advancedUpdate():void
		{
			if (complete || _frameChanged) {
				_sequenceFrame++;
				checkCallbacks();
			}
			updateSequence();
			
			// bugfix for null sequence during a sequence -- how it becomes null I have NO idea.
			if (!_sequence) { trace("sequence is null in advancedUpdate() on _sequenceFrame", _sequenceFrame); return; }
			playAnim(_sequence.animations[_sequenceIndex]);
			
			var frameBefore:int = frame;
			super.update();
			_frameChanged = frameBefore != frame;
		}
		
		private function updateSequence():void
		{
			// refactoring -Richard Marks
		   
			// if the current animation has not finished
			if (!complete) { return; }
			
			_sequenceIndex++;
			if (_sequenceIndex == _sequence.animations.length) {
					if (_sequence.loop) {
							_sequenceIndex = _sequenceFrame = 0;
					}
					else {
							_sequenceIndex--;
					}
			}
		}
		
		private function checkCallbacks():void
		{
			_sequence.updateCallbacks(_sequenceFrame);
		}
		
		private function playAnim(name:String):Anim
		{
			return super.play(name, false);
		}
		
		override public function play(name:String = "", reset:Boolean = false):Anim 
		{
			_sequence = null;
			return super.play(name, reset);
		}
		
		/**
		 * Add a Sequence.
		 * @param	name		Name of the sequence.
		 * @param	frames		Array of animation names to play through.
		 * @param	loop		If the sequence should loop.
		 * @return	A new Sequence object for the sequence.
		 */
		public function addSeq(name:String, animations:Array, loop:Boolean = true):AnimationSequence
		{
			if (_sequences[name]) throw new Error("Cannot have multiple sequences with the same name");
			
			// changed to use hasAnim function from my branch - Richard Marks
			for each (var anims:String in animations)
			{
				//if (!_anims[anims]) throw new Error("Undefined animations in sequence.");
				if (!hasAnim(anims)) 
				{ 
					throw new Error("Undefined animations in sequence.");
				}
			}
			
			animations = addSequenceHACK(name, animations);
			
			(_sequences[name] = new AnimationSequence(name, animations, loop))._parent = this;
			return _sequences[name];
		}
		
		// for the love of god, we've got to find a better solution
		private function addSequenceHACK(name:String, animations:Array):Array
		{
			// this hack adds a second animation to the sequence if only one anim is given
			// the added animation is the last frame of the given animation
			// the added animation name is name_DIRTY_HACK_
			
			if (animations.length > 1) { return animations; }
			
			var anim:Anim = Anim(_anims[animations[0]]);
			add(name + "_DIRTY_HACK_", [anim.frames[anim.frames.length - 1]], anim.frameRate, false);
			animations.push(name + "_DIRTY_HACK_");
			return animations;
		}
		 
		public function addCallback(name:String, callback:Function, frame:int, save:Boolean = true):void
		{
			_sequences[name].addCallback(callback, frame, save);
			_updater = advancedUpdate;
		}
		
		/**
		 * Plays an Sequence.
		 * @param	name		Name of the sequence to play.
		 * @param	reset		If the sequence should force-restart if it is already playing.
		 * @return	Sequence object representing the played sequence.
		 */
		public function playSeq(name:String = "", reset:Boolean = false):AnimationSequence
		{
			if (!reset && _sequence && _sequence._name == name) return _sequence;
			_sequence = _sequences[name];
			if (!_sequence)
			{
				// seq change bugfix - Richard Marks
				_sequenceIndex = _sequenceFrame = 0;
				return null;
			}
			_sequenceIndex = _sequenceFrame = 0;
			playAnim(_sequence.animations[0]);
			return _sequence;
		}
		
		// added by Richard Marks
		/**
		 * The currently playing sequence.
		 */
		public function get currentSequence():String { return _sequence ? _sequence._name : ""; }
		
		// made protected just in case we want to extend this -Richard Marks
		/** @private */ protected var _frameChanged:Boolean;
		/** @private */ protected var _sequences:Object = { };
		/** @private */ protected var _sequence:AnimationSequence;
		/** @private */ protected var _sequenceIndex:uint;
		/** @private */ protected var _sequenceFrame:uint;
		/** @private */ protected var _updater:Function;

		public function toString():String
		{
			return "AdvancedAnimation {\n" +
				"\tupdate method: " + ((_updater === simpleUpdate)? "SIMPLE" : "ADVANCED") + "\n" +
				"\tsequence index: " + _sequenceIndex + "\n" +
				"\tsequence frame: " + _sequenceFrame + "\n};\n";
		}
	}
}