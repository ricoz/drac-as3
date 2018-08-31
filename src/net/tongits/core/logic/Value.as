package net.tongits.core.logic
{
	public class Value
	{
		public static const JOKER:int = 0;
		public static const ACE:int = 1;
		public static const TWO:int = 2;
		public static const THREE:int = 3;
		public static const FOUR:int = 4;
		public static const FIVE:int = 5;
		public static const SIX:int = 6;
		public static const SEVEN:int = 7;
		public static const EIGHT:int = 8;
		public static const NINE:int = 9;
		public static const TEN:int = 10;
		public static const JACK:int = 11;
		public static const QUEEN:int = 12;
		public static const KING:int = 13;
	
		public static function getName(value:int):String {
			switch (value) {
				case JOKER: return "Joker";
				case ACE: return "Ace";
				case TWO: return "Two";
				case THREE: return "Three";
				case FOUR: return "Four";
				case FIVE: return "Five";
				case SIX: return "Six";
				case SEVEN: return "Seven";
				case EIGHT: return "Eight";
				case NINE: return "Nine";
				case TEN: return "Ten";
				case JACK: return "Jack";
				case QUEEN: return "Queen";
				case KING: return "King";
				default: throw new Error("Unknown Card Value (" + value + ")");
			}
		}
	}
}