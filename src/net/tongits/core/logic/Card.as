package net.tongits.core.logic
{
	public class Card
	{
		private var _value:int;
		private var _suit:int;
		
		public function Card(value:int, suit:int) {
			this.value = value;
			this.suit = suit;
		}
		
		public function get value():int {
			return _value;
		}
		
		public function set value(newval:int):void {
			// check if assigned value is valid
			Value.getName(newval);
			_value = newval;
		}
		
		public function get suit():int {
			return _suit;
		}
		
		public function set suit(newval:int):void {
			// checkif assigned value is valid
			Suit.getName(newval);
			_suit = newval;
		}
		
		public function clone():Card {
			return new Card(value, suit);
		}

		public function toString():String
		{
			// TODO: test for Joker and remove the
			// suit value since Joker's don't have a suit
			return "[Card: " + Value.getName(this.value)
					+ " of " + Suit.getName(this.suit) + "]";
		}
	}
}