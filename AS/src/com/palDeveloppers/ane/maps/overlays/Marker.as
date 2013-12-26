package com.palDeveloppers.ane.maps.overlays
{
	import com.palDeveloppers.ane.maps.LatLng;
	import com.palDeveloppers.ane.maps.Map;
	import com.palDeveloppers.ane.maps.map_internal;

	public class Marker
	{
		private static var nextId:int = 0;
		
		private var _id:int;
		private var _owner:Map;
		private var _latLng:LatLng;
		private var _title:String = "";
		private var _subtitle:String = "";
		private var _fillColor:uint = MarkerStyles.MARKER_COLOR_RED;
		private var _animatesDrop:Boolean;
		private var _infoWindowEnabled:Boolean = true;
		private var _showInfoWindowButton:Boolean;
		
		public function Marker(latLng:LatLng)
		{
			this.latLng = latLng;
			this._id = getNextMarkerId();
		}
		
		private static function getNextMarkerId():int
		{
			return nextId++;	
		}
		
		public function get id():int
		{
			return _id;
		}
		
		public function get owner():Map
		{
			return _owner;
		}
		
		map_internal function set owner(value:Map):void
		{
			_owner = value;
		}
		
		public function get animatesDrop():Boolean
		{
			return _animatesDrop;
		}
		
		public function set animatesDrop(value:Boolean):void
		{
			_animatesDrop = value;
		}
		
		public function get infoWindowEnabled():Boolean
		{
			return _infoWindowEnabled;
		}
		
		public function set infoWindowEnabled(value:Boolean):void
		{
			_infoWindowEnabled = value;
		}
		
		public function get latLng():LatLng
		{
			return _latLng;
		}
		
		public function set latLng(value:LatLng):void
		{
			_latLng = value;
		}
		
		public function get showInfoWindowButton():Boolean
		{
			return _showInfoWindowButton;
		}
		
		public function set showInfoWindowButton(value:Boolean):void
		{
			_showInfoWindowButton = value;
		}
		
		public function get title():String
		{
			return _title;
		}
		
		public function set title(value:String):void
		{
			_title = value;
		}
		
		public function get subtitle():String
		{
			return _subtitle;
		}
		
		public function set subtitle(value:String):void
		{
			_subtitle = value;
		}
		
		public function get fillColor():uint
		{
			return _fillColor;
		}
		
		public function set fillColor(value:uint):void
		{
			_fillColor = value;
		}
		
		public function openInfoWindow():void
		{
			_owner.map_internal::context.call("openMarker", _id);
		}
		
		public function closeInfoWindow():void
		{
			_owner.map_internal::context.call("closeMarker", _id);
		}
	}
}