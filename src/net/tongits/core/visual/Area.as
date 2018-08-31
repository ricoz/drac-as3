package net.tongits.core.visual
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.containers.Tile;
	import mx.events.FlexEvent;
	
	public class Area extends Tile
	{
		private var _bounds:Rectangle;
		
		public function Area() {
			cacheAsBitmap = true;
			clipContent = false;
			autoLayout = false;
			
			setStyle("horizontalAlign", "center");
			setStyle("horizontalGap", 2);
			setStyle("verticalGap", 2);
			
			setStyle("borderSides", "");
/* 			setStyle("paddingBottom", 10);
			setStyle("paddingTop", 10); */
			
			
//			addEventListener(FlexEvent.UPDATE_COMPLETE, handleUpdateComplete);
		}
		
		public function get bounds():Rectangle {
			if (_bounds == null) {
				_bounds = getBounds(stage);
			}
			
			return _bounds;
		}

		// from IDropManager
		public function accept(deck:IDroppable):Boolean {
			if (deck.intersects(bounds)) {
				// loop through all the decks contained in this area
				var decks:Array = getChildren();
				// we exclude the deck's self or parent deck (if it's a card)
				for (var i:int = decks.length-2; i >= 0; i--) {
					if (!(decks[i] is VisualDeck)) {
						continue;
					}
					var d:VisualDeck = decks[i];
					if (d.accept(deck)) {
						return true;
					}
				}
				
				// are we on the same deck? this is for the single card drag
				if ((decks.length > 0) && (decks[decks.length-1] is VisualDeck)) {
					var dd:VisualDeck = decks[decks.length-1];
					if (dd.accept(deck)) {
						return true;
					}
				}

				// can we drop on a blank area?
				if (accepted(deck)) {
//					var newDeck:VisualDeck = new VisualDeck();
					// we use a custom function to create the deck which may be overriden by sub classes
					var newDeck:VisualDeck = createDeck();
					newDeck.isDown = VisualCard(deck.getCards(false)[0]).isDown;
					addChild(newDeck);
					
					// position the deck where the card was dragged
					// we need to convert from content coordinate to global and then back again
					var p1:Point = deck.getGlobalPoint();
					var p2:Point = globalToContent(p1);
					
					// move the deck slightly to the lower right to give it a "dropped" effect
					newDeck.move(p2.x+DraggableObject.LIFT_OFFSET, p2.y+DraggableObject.LIFT_OFFSET);
					newDeck.push(deck);
					// manually trigger the move effect
					newDeck.validateNow();

					return true;
				}
				
				return false;
			} else {
				return false;
			}
		}
		
		// from IDropManager, the function to override
		public function accepted(deck:IDroppable):Boolean {
			// deck must not be empty to be accepted
			//if (deck.getCards(false).length > 0) {
				// the deck should be fully dragged inside the area
//				return deck.percentIntersected(bounds) == 100;
				// at least 10 percent has intersected
				//return deck.percentIntersected(bounds) > 10;
			//} else {
				return false; // do not accept anything for now
			//}
		}
		
		// we should also override this function to be able to create custom new decks
		protected function createDeck():VisualDeck {
			// we just create a default deck
			return new VisualDeck();
		}
		
		// the human hand area should override this
		public function isHuman():Boolean {
			return false;
		}

		protected function handleUpdateComplete(event:FlexEvent):void {
			trace("display list updated");
 			for each(var s:VisualDeck in getChildren()) {
				s.updateBounds();
			}
		}
	}
}