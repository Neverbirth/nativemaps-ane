package com.palDeveloppers.ane.maps
{
	import flash.events.Event;
	
	public class MapMouseEvent extends Event
	{
		public static var MARKER_SELECT:String="mapevent_select";
		public static var MARKER_DESELECT:String="mapevent_deselect";
		public static var INFO_BUTTON_CLICKED:String="infoButtonClicked";
		public var data:Object=null;
		public function MapMouseEvent(type:String,feature:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data=feature;
			super(type, bubbles, cancelable);
		}
	}
}