package net.tongits.core.logic
{
	public class Suit
	{
		
		public static const HEARTS:int = 0;
		public static const DIAMONDS:int = 1;
		public static const CLUBS:int = 2;
		public static const SPADES:int = 3;
			
		public static function isRed(suit:int):Boolean {
			return (suit == HEARTS || suit == DIAMONDS);
		}
		
		public static function getName(suit:int):String {
			switch (suit) {
				case HEARTS: return "Hearts";	
				case DIAMONDS: return "Diamonds";
				case CLUBS: return "Clubs";
				case SPADES: return "Spades";
				default: throw new Error("Unknown Suit (" + suit + ")");
			}
		}
	
	}
}