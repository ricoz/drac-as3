package net.tongits.core.visual
{
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	public interface IDroppable
	{
		function getCards(remove:Boolean=true):Array;
		function intersects(rect:Rectangle):Boolean;
		function percentIntersected(rect:Rectangle):Number;
		function getGlobalPoint():Point;
	}
}