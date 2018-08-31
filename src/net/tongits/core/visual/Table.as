package net.tongits.core.visual
{
	import mx.containers.Canvas;
	
	// TODO: can be a singleton
	public class Table extends Canvas
	{
		public function Table() {}
		
		// from IDropManager
		public function accept(deck:IDroppable):Boolean {
			var areas:Array = getChildren();
			
			// we exclude the topmost area which is the area where deck belongs
			for (var i:int = areas.length-2; i >= 0; i--) {
				var area:Area = areas[i];
				if (area.accept(deck)) {
					return true;
				}
			}
			
			return false;
		}
		
		// from IDropManager
		public function accepted(deck:IDroppable):Boolean {
			return true;
		}
	}
}