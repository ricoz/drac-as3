package net.tongits.core.visual
{
	internal interface IDropManager
	{
		function accept(deck:IDroppable):Boolean;
		function accepted(deck:IDroppable):Boolean;
	}
}