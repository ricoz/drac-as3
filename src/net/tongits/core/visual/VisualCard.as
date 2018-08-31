package net.tongits.core.visual
{
	import flash.display.BlendMode;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.events.EffectEvent;
	
	import net.tongits.core.logic.Card;

	public class VisualCard extends DraggableObject implements IDroppable
	{
		// the random y value used in the "messy" look
		public var ry:int;
		
		private var _card:Card;
		private var _isDown:Boolean;
		private var _gfx:Graphics;
		private var _prevParent:VisualDeck;
		
		// the deck's and area's bounds before a card from it is dragged
		private var _origDeckBounds:Rectangle;
		
		public function VisualCard(card:Card, isDown:Boolean = true) {
			super();

			// once this VisualCard's card is set it cannot be changed externally
			_card = card;

			// show the back?
			this.isDown = isDown;

			// create the graphic based on the card
			updateSkin();
			
			// use hand cursor for all cards instead of arrow cursor
			buttonMode = true;
			
			// visual cards can handle mouse down events
			addMouseDownListener();
			
			setStyle("borderSides", "");
		}
		
		public function get card():Card {
			return _card.clone();
		}

		public function get isDown():Boolean {
			return _isDown;
		}
		
		public function set isDown(value:Boolean):void {
			if (_isDown != value) {
				_isDown = value;
				updateSkin();
			}
		}
		
		private function get gfx():Graphics {
			if (_gfx == null) {
				_gfx = new Graphics();
			}
			
			return _gfx;
			
		}
		
		public function set prevParent(value:VisualDeck):void {
			_prevParent = value;
		}
		
		public function get prevParent():VisualDeck {
			if (_prevParent == null) {
				_prevParent = deck;
			}
			return _prevParent;
		}
		
		public function get deck():VisualDeck {
			return parent as VisualDeck;
		}
		
		public function get area():Area {
			return deck.parent as Area;
		}
		
		public function get table():Table {
			return area.parent as Table;
		}
		
		private function updateSkin():void {
			if (numChildren == 1) {
				removeChildAt(0);
			}
			
			if (_isDown) {
				addChild(gfx.createBack())
			} else {
				addChild(gfx.createCard(card));
			}
		}
		
		// from IDroppable
		public function getCards(remove:Boolean=true):Array {
			var cards:Array = new Array();
			
			if (remove && (parent != null)) {
				// we must save the deck to a variable to be able to access it after we have removed this card from it
				var d:VisualDeck = deck;

				cards.push(d.removeChild(this) as VisualCard);

				d.arrange();
			} else {
				cards.push(this);
			}
			
			return cards;
		}
		
		// from IDroppable
		public function intersects(rect:Rectangle):Boolean {
			return getBounds(stage).intersects(rect);
		}
		
		// from IDroppable
		public function percentIntersected(rect:Rectangle):Number {
			var myRect:Rectangle = getBounds(stage);
			var intersection:Rectangle = myRect.intersection(rect);
			
			var rectArea:Number = rect.width * rect.height;
			var myArea:Number = myRect.width * myRect.height;
			
			var intersectionArea:Number = intersection.width * intersection.height;
			
			// get the percentage relative to the smaller rectangle
			return Math.round(intersectionArea / Math.min(rectArea, myArea) * 100);
		}
		
		// fom IDroppable
		public function getGlobalPoint():Point {
			return deck.contentToGlobal(new Point(x, y));
		}
		
		public function bringToTop():void {
  			table.setChildIndex(area, table.numChildren-1);
 			area.setChildIndex(deck, area.numChildren-1);
			deck.setChildIndex(this, deck.numChildren-1);			
		}
		
		public override function drag():void {
			if (deck.dragType == DeckDragType.NO_DRAG) {
				return;
			} else if ((deck.getChildIndex(this) == 0) && (deck.dragType == DeckDragType.WITH_ROOT)) {
				deck.drag();
			} else if ((deck.getChildIndex(this) == 0) && (deck.dragType == DeckDragType.ROOT_ONLY)) {
				deck.drag();
			} else if ((deck.dragType == DeckDragType.NO_ROOT) || (deck.dragType == DeckDragType.WITH_ROOT) ||
						((deck.dragType == DeckDragType.TOP_ONLY) && (deck.getChildIndex(this) == deck.numChildren-1))) {

				// update the deck's bounds before moving the card
				var adjust:Number = 0;
				// but first check if we're dragging the top card
/* 				if (deck.getChildIndex(this) == deck.numChildren-1) {
					trace("dragging top card (" + deck.getChildIndex(this) + ")" + " deck.numChildren is " + deck.numChildren);
					adjust = -1;
				} */

	 			// set the card's z order to the highest
	 			bringToTop();

				// then update the deck's bounds
//				deck.updateBounds(adjust);
				deck.updateBounds(-1);

				super.drag();
			}
		}
		
		// automatically called when mouse up event is dispatched
		protected override function drop():void {
			if (deck.dragType == DeckDragType.NO_DRAG) {
				return;
			}

			super.drop();
			
			if (!table.accept(this)) {
				// check if we're completely outside our own area
				if (percentIntersected(area.bounds) == 0) {
					rejected();
				} else {
					// check if we can drop to a blank space or another deck within this card's area
					if (!area.accept(this)) {
						rejected();
					}	
				}
			}
		}
		
		private function rejected():void {
			if (deck.dragType == DeckDragType.TOP_ONLY) {
				zoomBack();
			} else {
				deck.arrange(-1);
				var p:Point = deck.getLastCardPosition();
				animatedMove(p.x, p.y);
			}	
		}
		
		protected override function handleEffectEnd(event:EffectEvent):void {
			super.handleEffectEnd(event);
			deck.arrange(-1);
			deck.updateBounds();
		}
		
		public function clone():VisualCard {
			return new VisualCard(card, isDown);
		}

/* 		public function invert(clear:Boolean=false):void {
			if (clear) {
				if (numChildren > 1) {
					removeChildAt(1);
				} // else not inverted
			} else {
				if (numChildren < 2) {
					addChild(gfx.createCard(card)).blendMode = BlendMode.INVERT;
				} // else already inverted				
			}
		} */

		public function removeInvert():void {
			if (numChildren > 1) {
				removeChildAt(1);
			}
		}

		public function invert():void {
			if (numChildren > 1) {
				// remove the invert
				removeChildAt(1);
			} else if (numChildren < 2) {
				// invert the card
				addChild(gfx.createCard(card)).blendMode = BlendMode.INVERT;
			}
		}

		public override function toString():String {
			return "[VisualCard(card:" + _card + ", isDown:" + _isDown + ")]";
		}
	}
}