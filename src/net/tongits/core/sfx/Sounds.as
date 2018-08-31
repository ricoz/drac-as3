package net.tongits.core.sfx
{
	import flash.media.Sound;
	
	public class Sounds
	{
		private static var _instance:Sounds;

 		[Embed(source="../../../../../assets/sounds/____.mp3")]
		private var CardAddedSound:Class;

/* 		[Embed(source="../../../../../assets/sounds/____.mp3")]
		private var DropHandSound:Class; */

		[Embed(source="../../../../../assets/sounds/____.mp3")]
		private var CashSound:Class;

		[Embed(source="../../../../../assets/sounds/____.mp3")]
		private var SapawSound:Class;

		[Embed(source="../../../../../assets/sounds/____.mp3")]
		private var LiftCardSound:Class;
		
		[Embed(source="../../../../../assets/sounds/____.mp3")]
		private var DropCardSound:Class;

/*  		[Embed(source="../../../../../assets/sounds/____.mp3")]
		private var DumpCardSound:Class; */

		[Embed(source="../../../../../assets/sounds/____.mp3")]
		private var WhooshCardSound:Class;

		[Embed(source="../../../../../assets/sounds/____.mp3")]
		private var ApplauseSound:Class;

		[Embed(source="../../../../../assets/sounds/____.mp3")]
		private var BooSound:Class;

		function Sounds(enforcer:SingletonEnforcer) {}
		
		public static function getInstance():Sounds {
			if (Sounds._instance == null) {
				Sounds._instance = new Sounds(new SingletonEnforcer);
			}
			
			return Sounds._instance;
		}
		
		public function playSound(type:String):void {
 			var clazz:Class = this[type];
			var sound:Sound = new clazz() as Sound;
			sound.play();
			
			trace("playing sound " + type);
		}
	}
}

class SingletonEnforcer {}