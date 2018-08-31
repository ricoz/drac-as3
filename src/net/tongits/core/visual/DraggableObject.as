package net.tongits.core.visual
{
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	
	import mx.containers.Canvas;
	import mx.effects.Move;
	import mx.events.EffectEvent;
	
	import net.tongits.core.sfx.SoundType;
	import net.tongits.core.sfx.Sounds;

	// this should be internal based on good practice but
	// it causes weird graphical errors when made internal
	public class DraggableObject extends Canvas
	{
		public static const LIFT_OFFSET:int = 3;

		private var _moveEffect:Move;
		private var _oldX:int;
		private var _oldY:int;
		private var _dragFilters:Array;

		public function DraggableObject() {
			setStyle("borderStyle", "none");
			setStyle("borderSides", "");
			cacheAsBitmap = true;
			cachePolicy = "on";
			clipContent = false;

			_moveEffect = new Move();
			_moveEffect.suspendBackgroundProcessing = true;
			_moveEffect.duration = 500;
		}
		
		// visual decks should not handle the mouse down
		public function addMouseDownListener():void {
			// add drag & drop handlers, add the mouseup listener dynamically during mousedown
			addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown/*, false, 0, true*/);
		}
		
		public function removeMouseDownListener():void {
			// add drag & drop handlers, add the mouseup listener dynamically during mousedown
			removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
			buttonMode = false;
		}
		
		public function animatedMove(x:int, y:int):void {
			addEventListener(EffectEvent.EFFECT_START, handleEffectStart/*, false, 0, true*/);
			_moveEffect.xFrom = this.x;
			_moveEffect.yFrom = this.y;
			_moveEffect.xTo = x;
			_moveEffect.yTo = y;
			
			_moveEffect.play([this]);
		}

		private function handleMouseDown(event:MouseEvent):void {
			stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove/*, false, 0, true*/);
			addEventListener(MouseEvent.MOUSE_UP, handleMouseUpNoMove/*, false, 0, true*/);
		}
		
		private function handleMouseUpNoMove(event:MouseEvent):void {
			// remove mouse move listener
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			removeEventListener(MouseEvent.MOUSE_UP, handleMouseUpNoMove);
		}
		
		private function handleMouseMove(event:MouseEvent):void {
			// remove mouse move listener
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove)
			removeEventListener(MouseEvent.MOUSE_UP, handleMouseUpNoMove);

			drag();
		}
		
		private function handleMouseUp(event:MouseEvent):void {
			// remove mouse move listener
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);

			drop();
		}

		public function drag():void {
			startDrag();
			filters = dragFilters;
			_oldX = x;
			_oldY = y;
			
			// move this object slightly to the upper left to give it a "lifted" effect
			x -= LIFT_OFFSET;
			y -= LIFT_OFFSET;
			
			// sound effect
			Sounds.getInstance().playSound(SoundType.LIFT_CARD_SOUND);

			// dynamically add the mouse up listener
			stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp/*, false, 0, true*/);
		}
		
		protected function drop():void {
			Sounds.getInstance().playSound(SoundType.DROP_CARD_SOUND);
			stopDrag();
			filters = null;
		}
		
		public function zoomBack():void {
			animatedMove(_oldX, _oldY);
		}

		private function get dragFilters():Array {
			// Create the array if it hasn't been made yet
			if (_dragFilters == null) {
				_dragFilters = new Array();

				// add a drop shadow effect to give the card or deck a lifted look
				var dropShadow:DropShadowFilter = new DropShadowFilter(6, 45, 0x202020, .65);
				_dragFilters.push(dropShadow);
			}
			
			return _dragFilters;
		}

		protected function handleEffectStart(event:EffectEvent):void {
			removeEventListener(EffectEvent.EFFECT_START, handleEffectStart);

			// only do this to the single cards which handle the mouse down events
			if (hasEventListener(MouseEvent.MOUSE_DOWN)) {
				removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
				addEventListener(EffectEvent.EFFECT_END, handleEffectEnd/*, false, 0, true*/);
			}
		}
		
		protected function handleEffectEnd(event:EffectEvent):void {
			addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown/*, false, 0, true*/);
			removeEventListener(EffectEvent.EFFECT_END, handleEffectEnd);
		}
	}
}