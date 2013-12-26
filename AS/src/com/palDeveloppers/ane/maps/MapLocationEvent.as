package com.palDeveloppers.ane.maps
{
	import flash.events.Event;
	
	public class MapLocationEvent extends Event
	{
		public static var USER_LOCATION_FAILED:String="userLocationFailed";
		public static var USER_LOCATION_UPDATED:String="userLocationUpdated";
		
		private var _data:Object;
		
		public function MapLocationEvent(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_data = data;
		}
		
		public function get data():Object
		{
			return _data;
		}
	}
}