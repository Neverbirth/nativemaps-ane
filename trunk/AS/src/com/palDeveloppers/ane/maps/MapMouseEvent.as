package com.palDeveloppers.ane.maps
{
	import flash.events.Event;
	
	public class MapMouseEvent extends Event
	{
		public static const MARKER_SELECT:String="markerSelect";
		public static const MARKER_DESELECT:String="markerDeselect";
		public static const INFO_BUTTON_CLICKED:String="infoButtonClicked";
		public static const MAP_TAP:String="mapTap";
		public static const MAP_LONG_PRESS:String="mapLongPress";
		public var data:Object=null;
		public function MapMouseEvent(type:String,feature:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data=feature;
			super(type, bubbles, cancelable);
		}
	}
}