package com.palDeveloppers.ane.maps
{
	import flash.events.Event;
	
	public class MapEvent extends Event
	{
		public static const TILES_LOADED_PENDING:String="tilesLoadedPending";
		public static const TILES_LOADED:String="tilesLoaded";
		public static const MAP_LOAD_ERROR:String="mapLoadError";
		public static const REGION_CHANGE:String="regionChange";
		public static const REGION_CHANGED:String="regionChanged";
		public function MapEvent(type:String,feature:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}