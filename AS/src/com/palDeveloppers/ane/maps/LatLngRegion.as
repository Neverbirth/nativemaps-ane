package com.palDeveloppers.ane.maps
{
	public class LatLngRegion
	{
		private var _northeast:LatLng;
		private var _southwest:LatLng;
		
		public function LatLngRegion(northeast:LatLng, southwest:LatLng)
		{
			_northeast=northeast;
			_southwest=southwest;
		}
		
		public function northeast():LatLng
		{
			return _northeast;
		}
		
		public function southwest():LatLng
		{
			return _southwest;
		}
		
		public function toString():String
		{
			return "ne: " + _northeast.toString() + ", sw: " + _southwest.toString();
		}
	}
}