package com.palDeveloppers.ane.maps.overlays
{
	import com.palDeveloppers.ane.maps.LatLng;

	public class Polyline
	{
		private var _id:int;
		private var _pts:Vector.<LatLng>;
		private static var nextId:int = 0;
		
		public function Polyline(points:Vector.<LatLng>)
		{
			_pts = points;
			this._id = getNextPolylineId();
		}
		
		private static function getNextPolylineId():int
		{
			return nextId++;	
		}
		
		public function get id():int
		{
			return _id;
		}
		
		public function get points():Vector.<LatLng>
		{
			return _pts;
		}
	}
}