package net.tongits.core.visual
{
	import flash.display.DisplayObject;
	
	import mx.core.UIComponent;
	
	import net.tongits.core.logic.Card;
	import net.tongits.core.logic.Suit;
	import net.tongits.core.logic.Value;
	
	// TODO: make singleton
	public class Graphics
	{
		[Embed(source="../../../../../assets/cards/default/back01.png")]
		private var Back:Class;
		
		[Embed(source="../../../../../assets/cards/default/2c.png")]
		private var TwoClubs:Class;
		
		[Embed(source="../../../../../assets/cards/default/2d.png")]
		private var TwoDiamonds:Class;
		
		[Embed(source="../../../../../assets/cards/default/2h.png")]
		private var TwoHearts:Class;
		
		[Embed(source="../../../../../assets/cards/default/2s.png")]
		private var TwoSpades:Class;
		
		[Embed(source="../../../../../assets/cards/default/3c.png")]
		private var ThreeClubs:Class;
		
		[Embed(source="../../../../../assets/cards/default/3d.png")]
		private var ThreeDiamonds:Class;
		
		[Embed(source="../../../../../assets/cards/default/3h.png")]
		private var ThreeHearts:Class;
		
		[Embed(source="../../../../../assets/cards/default/3s.png")]
		private var ThreeSpades:Class;
		
		[Embed(source="../../../../../assets/cards/default/4c.png")]
		private var FourClubs:Class;
		
		[Embed(source="../../../../../assets/cards/default/4d.png")]
		private var FourDiamonds:Class;
		
		[Embed(source="../../../../../assets/cards/default/4h.png")]
		private var FourHearts:Class;
		
		[Embed(source="../../../../../assets/cards/default/4s.png")]
		private var FourSpades:Class;
		
		[Embed(source="../../../../../assets/cards/default/5c.png")]
		private var FiveClubs:Class;
		
		[Embed(source="../../../../../assets/cards/default/5d.png")]
		private var FiveDiamonds:Class;
		
		[Embed(source="../../../../../assets/cards/default/5h.png")]
		private var FiveHearts:Class;
		
		[Embed(source="../../../../../assets/cards/default/5s.png")]
		private var FiveSpades:Class;
		
		[Embed(source="../../../../../assets/cards/default/6c.png")]
		private var SixClubs:Class;
		
		[Embed(source="../../../../../assets/cards/default/6d.png")]
		private var SixDiamonds:Class;
		
		[Embed(source="../../../../../assets/cards/default/6h.png")]
		private var SixHearts:Class;
		
		[Embed(source="../../../../../assets/cards/default/6s.png")]
		private var SixSpades:Class;
		
		[Embed(source="../../../../../assets/cards/default/7c.png")]
		private var SevenClubs:Class;
		
		[Embed(source="../../../../../assets/cards/default/7d.png")]
		private var SevenDiamonds:Class;
		
		[Embed(source="../../../../../assets/cards/default/7h.png")]
		private var SevenHearts:Class;
		
		[Embed(source="../../../../../assets/cards/default/7s.png")]
		private var SevenSpades:Class;
		
		[Embed(source="../../../../../assets/cards/default/8c.png")]
		private var EightClubs:Class;
		
		[Embed(source="../../../../../assets/cards/default/8d.png")]
		private var EightDiamonds:Class;
		
		[Embed(source="../../../../../assets/cards/default/8h.png")]
		private var EightHearts:Class;
		
		[Embed(source="../../../../../assets/cards/default/8s.png")]
		private var EightSpades:Class;
		
		[Embed(source="../../../../../assets/cards/default/9c.png")]
		private var NineClubs:Class;
		
		[Embed(source="../../../../../assets/cards/default/9d.png")]
		private var NineDiamonds:Class;
		
		[Embed(source="../../../../../assets/cards/default/9h.png")]
		private var NineHearts:Class;
		
		[Embed(source="../../../../../assets/cards/default/9s.png")]
		private var NineSpades:Class;
		
		[Embed(source="../../../../../assets/cards/default/10c.png")]
		private var TenClubs:Class;
		
		[Embed(source="../../../../../assets/cards/default/10d.png")]
		private var TenDiamonds:Class;
		
		[Embed(source="../../../../../assets/cards/default/10h.png")]
		private var TenHearts:Class;
		
		[Embed(source="../../../../../assets/cards/default/10s.png")]
		private var TenSpades:Class;
		
		[Embed(source="../../../../../assets/cards/default/jc.png")]
		private var JackClubs:Class;
		
		[Embed(source="../../../../../assets/cards/default/jd.png")]
		private var JackDiamonds:Class;
		
		[Embed(source="../../../../../assets/cards/default/jh.png")]
		private var JackHearts:Class;
		
		[Embed(source="../../../../../assets/cards/default/js.png")]
		private var JackSpades:Class;
		
		[Embed(source="../../../../../assets/cards/default/qc.png")]
		private var QueenClubs:Class;
		
		[Embed(source="../../../../../assets/cards/default/qd.png")]
		private var QueenDiamonds:Class;
		
		[Embed(source="../../../../../assets/cards/default/qh.png")]
		private var QueenHearts:Class;
		
		[Embed(source="../../../../../assets/cards/default/qs.png")]
		private var QueenSpades:Class;
		
		[Embed(source="../../../../../assets/cards/default/kc.png")]
		private var KingClubs:Class;
		
		[Embed(source="../../../../../assets/cards/default/kd.png")]
		private var KingDiamonds:Class;
		
		[Embed(source="../../../../../assets/cards/default/kh.png")]
		private var KingHearts:Class;
		
		[Embed(source="../../../../../assets/cards/default/ks.png")]
		private var KingSpades:Class;
		
		[Embed(source="../../../../../assets/cards/default/ac.png")]
		private var AceClubs:Class;
		
		[Embed(source="../../../../../assets/cards/default/ad.png")]
		private var AceDiamonds:Class;
		
		[Embed(source="../../../../../assets/cards/default/ah.png")]
		private var AceHearts:Class;
		
		[Embed(source="../../../../../assets/cards/default/as.png")]
		private var AceSpades:Class;

		// default widht and height of the cards
		public static const WIDTH:int = 50;
		public static const HEIGHT:int = 68;
		
		public function createCard(card:Card):UIComponent {
			var clazz:Class = this[Value.getName(card.value) + Suit.getName(card.suit)];
			var s:DisplayObject = new clazz();
			s.cacheAsBitmap = true;
			s.width = WIDTH;
			s.height = HEIGHT;

			var uic:UIComponent = new UIComponent();
			uic.cacheAsBitmap = true;
			uic.cachePolicy = "on";
			uic.width = WIDTH;
			uic.height = HEIGHT;
			uic.addChild(s);
			return uic;
		}

		public function createBack():UIComponent {
			var s:DisplayObject = new Back();
			s.cacheAsBitmap = true;
			s.width = WIDTH;
			s.height = HEIGHT;

			var uic:UIComponent = new UIComponent();
			uic.cacheAsBitmap = true;
			uic.cachePolicy = "on";
			uic.width = WIDTH;
			uic.height = HEIGHT;
			uic.addChild(s);
			return uic;
		}
	}
}