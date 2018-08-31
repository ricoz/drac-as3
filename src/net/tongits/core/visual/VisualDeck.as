package net.tongits.core.visual
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.events.ChildExistenceChangedEvent;
	import mx.events.EffectEvent;
	
	import net.tongits.core.logic.Card;
	import net.tongits.core.logic.Suit;

	public class VisualDeck extends DraggableObject implements IDroppable, IDropManager
	{
		// the gap between cards when drawn
		private const GAP:int = 18;
		
		private var _dragType:int;
		private var _origDragType:int;
		private var _drawType:int;
		private var _isDown:Boolean;
		private var _bounds:Rectangle;

		public function VisualDeck(dragType:int = DeckDragType.WITH_ROOT,
									drawType:int = DeckDrawType.HORIZONTAL, isDown:Boolean = true) {
			super();

			this.dragType = dragType;
			this.drawType = drawType;
			this.isDown = isDown;
			
			if ((dragType == DeckDragType.NO_ROOT) || (drawType == DeckDrawType.STACK)) {
				width = Graphics.WIDTH;
				height = Graphics.HEIGHT;
				
				setStyle("borderSides", "left top right bottom");
				setStyle("backgroundColor", 0xffffff);
				setStyle("backgroundAlpha", 0.25);
				setStyle("borderStyle", "solid");
				setStyle("cornerRadius", 10);
			}
			
			// automatically remove the object from the display list when empty
			addEventListener(ChildExistenceChangedEvent.CHILD_REMOVE, handleChildRemove, false, 0, true);
			addEventListener(ChildExistenceChangedEvent.CHILD_ADD, handleChildAdd, false, 0, true);
			
/* 			scaleX = .85;
			scaleY = .85; */
		}
		
		public function get dragType():int {
			return _dragType;
		}
		
		public function set dragType(value:int):void {
			if ((value != DeckDragType.NO_ROOT) && (value != DeckDragType.WITH_ROOT) &&
				(value != DeckDragType.NO_DRAG) && (value != DeckDragType.TOP_ONLY) &&
				(value != DeckDragType.ROOT_ONLY)) {
				throw new Error("Invalid deck drag type!");
			}
			
			_dragType = value;

			// update button modes, do this if we have at least 1 card in this deck
			if (numChildren) {
				// TODO: refactor, create a separate function
				if (_dragType == DeckDragType.TOP_ONLY) {
					setButtonMode(false);
					VisualCard(getChildAt(numChildren-1)).buttonMode = true;
				} else if (_dragType == DeckDragType.ROOT_ONLY) {
					setButtonMode(false);
					VisualCard(getChildAt(0)).buttonMode = true;
				} else {
					updateButtonMode();
				}
			}

			// update border
			if ((dragType == DeckDragType.NO_ROOT) || (drawType == DeckDrawType.STACK)) {
				width = Graphics.WIDTH;
				height = Graphics.HEIGHT;
				
				setStyle("borderSides", "left top right bottom");
				setStyle("backgroundColor", 0xffffff);
				setStyle("backgroundAlpha", 0.25);
				setStyle("borderStyle", "solid");
				setStyle("cornerRadius", 10);
			} else {
				setStyle("borderSides", "");
				setStyle("backgroundColor", undefined);
				setStyle("backgroundAlpha", 1);
				setStyle("borderStyle", "none");
				setStyle("cornerRadius", 0);

			}
		}
		
		public function get drawType():int {
			return _drawType;
		}
		
		public function set drawType(value:int):void {
			if ((value != DeckDrawType.HORIZONTAL) && (value != DeckDrawType.VERTICAL) && (value != DeckDrawType.STACK)) {
				throw new Error("Invalid deck draw type!");
			}
			
			_drawType = value;
			arrange();

			// update border
			if ((dragType == DeckDragType.NO_ROOT) || (drawType == DeckDrawType.STACK)) {
				width = Graphics.WIDTH;
				height = Graphics.HEIGHT;
				
				setStyle("borderSides", "left top right bottom");
				setStyle("backgroundColor", 0xffffff);
				setStyle("backgroundAlpha", 0.25);
				setStyle("borderStyle", "solid");
				setStyle("cornerRadius", 10);
			} else {
				setStyle("borderSides", "");
				setStyle("backgroundColor", undefined);
				setStyle("backgroundAlpha", 1);
				setStyle("borderStyle", "none");
				setStyle("cornerRadius", 0);
			}
		}

		public function get isDown():Boolean {
			return _isDown;
		}
		
		public function set isDown(value:Boolean):void {
			_isDown = value;
			
			for each (var card:VisualCard in getChildren()) {
				card.isDown = _isDown;
			}
		}
		
		protected function get bounds():Rectangle {
			if (_bounds == null) {
				_bounds = getBounds(stage);
			}
			
			return _bounds;
		}
		
		// TODO: this one is ugly, fix this, we should not worry about updating the deck's bounds
		public function updateBounds(adjust:Number=0):void {
			// this is a weird case, the deck does not update its bounds properly even after removing a card
			_bounds = getBounds(stage);
			// we use this to adjust the deck's width if we drag the top card
			if (drawType == DeckDrawType.HORIZONTAL) {
				_bounds.width += (GAP * adjust);	
			}

			if ((dragType != DeckDragType.NO_ROOT) && (drawType != DeckDrawType.STACK)) {
 				width = _bounds.width;
				height = _bounds.height;
			}
		}
		
		public function get area():Area {
			return parent as Area;
		}
		
		public function get table():Table {
			return area.parent as Table;
		}
		
		public function isEmpty():Boolean {
			return (getChildren().length == 0);
		}

		public function createPack():void {
			for (var i:int = 0; i < 13; i++) {
				addChild(new VisualCard(new Card(i+1, Suit.CLUBS), isDown));
				addChild(new VisualCard(new Card(i+1, Suit.DIAMONDS), isDown));
				addChild(new VisualCard(new Card(i+1, Suit.HEARTS), isDown));
				addChild(new VisualCard(new Card(i+1, Suit.SPADES), isDown));
			}
			
			// move the cards to the appropriate locations
			arrange();
		}
		
		public function shuffle():void {
			if (isEmpty()) {
				throw new DeckEmptyError();
			}

			// do a switch shuffle 3 times
			for (var i:int = 0; i < 3; i++) {
				for each (var card:VisualCard in getChildren()) {
					var ridx:uint = Math.random() * (getChildren().length-1);
					ridx = Math.round(ridx);
					// insert the current card to a random slot
					setChildIndex(card, ridx);
				}
			}
			
			// update the cards' positions
			arrange();
		}
		
		public function clear():void {
			if (isEmpty()) {
//				throw new DeckEmptyError();
				return;
			}
			
			removeEventListener(ChildExistenceChangedEvent.CHILD_REMOVE, handleChildRemove);
			removeAllChildren();
			addEventListener(ChildExistenceChangedEvent.CHILD_REMOVE, handleChildRemove, false, 0, true);
		}

		private function canDrop(deck:IDroppable):Boolean {
			if (deck.intersects(bounds) && accepted(deck)) {
				return true;
			} else {
				return false;
			}
		}
				
		// from IDropManager
		public function accept(deck:IDroppable):Boolean {
			if (canDrop(deck)) {
				push(deck);
				return true;
			} else {
				return false;
			}
		}
		
		// from IDropManager, the function to override
		public function accepted(deck:IDroppable):Boolean {
			// deck must not be empty to be accepted
			return deck.getCards(false).length > 0;
		}
		
		// use only in the dealing process
		public function push(deck:IDroppable):void {
			var cards:Array = deck.getCards();
			
			for each (var card:VisualCard in cards) {
				addChild(card);
			}
			
			arrange();
		}
		
		public function pop():IDroppable {
			var card:VisualCard = getChildAt(numChildren-1) as VisualCard
			return card;
		}

		public function arrange(offset:Number=0):void {
			offset > 0 ? offset=0 : 0;

			if (isEmpty()) {
				return;
			}
			
			// arrange cards horizontally
			var cards:Array = getChildren();
			
			if (drawType == DeckDrawType.HORIZONTAL) {
				for (var i:int = 0; i < cards.length + offset; i++) {
					cards[i].move(GAP * i, cards[i].ry);
					VisualCard(cards[i]).isDown = isDown;
				}				
			} else if (drawType == DeckDrawType.STACK) {
				// algorithm taken from my old tongits game
				var pos:int = 0;
				var cx:int = 0;
				var cy:int = 0;
				for (var j:int = 0; j < cards.length; j++) {
					cards[j].move(cx, cy);
					VisualCard(cards[j]).isDown = isDown;
					// adjust every 5 cards
					if (!(j % 5)) {
						pos++;
					}
					cx = (pos*2);
					cy = pos;
				}
			} else if (drawType == DeckDrawType.VERTICAL) {
				for (var k:int = 0; k < cards.length + offset; k++) {
					cards[k].move(0, GAP * k);
					VisualCard(cards[k]).isDown = isDown;
				}
			}
		
			// update the bounding rect
			if (offset == 0) {
				updateBounds();
			}
		}
		
		// from IDroppable
		public function getCards(remove:Boolean=true):Array {
			var cards:Array = new Array();
			
			for each (var card:VisualCard in getChildren()) {
				cards.push(card);
			}
			
			if (remove) {
				removeAllChildren();
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

		// from IDroppable
		public function getGlobalPoint():Point {
			return Area(parent).contentToGlobal(new Point(x, y));
		}
		
		private function randomY():Number {
			// set the card's y to a random value to create a "messy" deck
/* 			var ry:int = Math.random() * 3;
			ry = Math.round(ry);
			if (Math.round(Math.random() * 1)) {
				ry = -ry;
			} */ // else positive

			var ry:int = Math.random() * 4;
			ry = Math.round(ry);
			return ry;
		}

		// used for adding cards
		public function getNextSlotPosition():Point {
			if (drawType == DeckDrawType.HORIZONTAL) {
				
				var dx:int = numChildren * GAP;
				var dy:int = randomY();
	
				// we must return x y in reference to global coordinate system
				return localToGlobal(new Point(dx, dy));
			} else if (drawType == DeckDrawType.STACK) {
				if (isEmpty()) {
					return localToGlobal(new Point());
				}
				// returning the x, y of the top card is sufficient
				var topCard:VisualCard = getChildAt(getChildren().length-1) as VisualCard;
				return localToGlobal(new Point(topCard.x, topCard.y));
			} else {
				// 0, 0
				return localToGlobal(new Point());
			}
		}

		// used for returning cards to the same deck
		public function getLastCardPosition():Point {
			var x:int = (numChildren-1) * GAP;
			var y:int = 0;

			return new Point(x, y);
		}

		public override function drag():void {
			// set z level to highest
			table.setChildIndex(area, table.numChildren-1);
			area.setChildIndex(this, area.numChildren-1);

			super.drag();
		}
		
		protected override function drop():void {
			super.drop();
			
			// check if we can drop to a certain area in the table
			if (!table.accept(this)) {
				// find out if there is an existing deck underneath this deck
				// we should start checking from the topmost deck but
				// since this is the topmost deck we exclude ourself
				var decks:Array = area.getChildren();
				for (var j:int = decks.length-2; j >= 0; j--) {
					var deck:VisualDeck = decks[j];
					if (deck.accept(this)) {
						return;
					}
				}

				// check if we're outside our own area
				if (percentIntersected(area.bounds) < 100) {
					zoomBack();
					return;
				}
			} else {
				return;
			}

			// we're still on the same area so we just move the deck slightly to the lower right to give it a "dropped" effect
			x += DraggableObject.LIFT_OFFSET;
			y += DraggableObject.LIFT_OFFSET;
			
			// update the bounding rect
			updateBounds();
		}
		
		protected function handleChildAdd(event:ChildExistenceChangedEvent):void {
			var card:VisualCard = event.relatedObject as VisualCard;
			
			card.ry = randomY();
			
			// update the buttonModes
			if (dragType == DeckDragType.TOP_ONLY) {
				setButtonMode(false);
				// set the buttonMode of the card that is about to be added
				card.buttonMode = true;
			} else if (dragType == DeckDragType.ROOT_ONLY) {
				if (numChildren == 1) {
					// this is the root card
					card.buttonMode = true;
				}
//				} else {
//					VisualCard(getChildAt(0)).buttonMode = true;
//				}
			} else if (dragType != DeckDragType.NO_DRAG) {
				card.buttonMode = true;
			} else {
				card.buttonMode = false;
			}
		}
		
		// TODO: blog about this behavior, the event happens just when 
		//       a child is about to be removed NOT AFTER a child was removed
		protected function handleChildRemove(event:ChildExistenceChangedEvent):void {
			if (dragType == DeckDragType.NO_DRAG) {
				return;
			}

			var card:VisualCard = event.relatedObject as VisualCard;
			
			// set the card's previous parent to this deck
			card.prevParent = this;
			
			// since the child was about to be removed, the number of children should be 1 not 0
			if (getChildren().length == 1) {
				if ((dragType != DeckDragType.NO_ROOT) && (drawType != DeckDrawType.STACK)) {
					// check if we have a parent, since we can also create VisualDecks with no parent
					if (parent != null) {
						parent.removeChild(this);
					}
				}
			} else {
				// update the buttonModes
				if (dragType == DeckDragType.TOP_ONLY) {
					setButtonMode(false);
					// set the buttonMode of the new top card to true note that
					// the top card is actually still the 2nd one on top, so we
					// use numChildren-2 instead of just numChildren-1
					var topCard:VisualCard = getChildAt(numChildren-2) as VisualCard;
					topCard.buttonMode = true;
				}
			}
		}
		
		private function setButtonMode(mode:Boolean):void {
			for each (var card:VisualCard in getChildren()) {
				card.buttonMode = mode;
			}
		}
		
		private function updateButtonMode():void {
			switch (dragType) {
				case DeckDragType.NO_ROOT:
					setButtonMode(true);
					break;
				case DeckDragType.NO_DRAG:
					setButtonMode(false);
					break;
				case DeckDragType.TOP_ONLY:
					setButtonMode(false);
					// set the top card's buttonMode to true
					break;
				case DeckDragType.WITH_ROOT:
					setButtonMode(true);
					break
				case DeckDragType.ROOT_ONLY:
					setButtonMode(false);
					break;
				default:
				throw new Error("Invalid deck drag type!");
				
			}
		}
		
		public function clone():VisualDeck {
			var newDeck:VisualDeck = new VisualDeck(dragType, drawType, isDown);
			// add clones of the visual cards
			for each (var card:VisualCard in getChildren()) {
				// addChild() not push()
				newDeck.addChild(card.clone());
			}
			return newDeck;
		}
		
		// override the effect handlers to avoid dragging the deck while zooming
		protected override function handleEffectStart(event:EffectEvent):void {
			super.handleEffectStart(event);

			_origDragType = dragType;
			dragType = DeckDragType.NO_DRAG;

			// single cards are the only ones that handle the end effect event so we add our own
			addEventListener(EffectEvent.EFFECT_END, handleEffectEnd, false, 0, true);
		}
		
		protected override function handleEffectEnd(event:EffectEvent):void {
			dragType = _origDragType;
		}
		
		public function sort():void {
			// sort cards by value from lowest to highest, not a problem with same value sets

			for (var i:int = 1; i < numChildren; i++) {
				var key:VisualCard = getChildAt(i) as VisualCard;
				// compare the key to the cards in our sorted list
				var j:Number = i-1;
				for (j = i-1; j >= 0; j--) {
					var card:VisualCard = getChildAt(j) as VisualCard;
					if ((card.card.value > key.card.value)) {
						// move the card to the left
						setChildIndex(key, j);
					} else break;
				}
			}			
		}

		public override function toString():String {
			var output:String = "";
			for each (var card:VisualCard in getChildren()) {
				output += card;
				output += "\n";
			}
			return output;
		}
	}
}