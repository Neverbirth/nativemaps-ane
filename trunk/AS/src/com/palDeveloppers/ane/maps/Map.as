package com.palDeveloppers.ane.maps
{
	import com.palDeveloppers.ane.maps.overlays.Marker;
	import com.palDeveloppers.ane.maps.overlays.Polyline;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.system.Capabilities;
	
	[Event(name="tilesLoadedPending", type="com.palDeveloppers.ane.maps.MapEvent")]
	[Event(name="tilesLoaded", type="com.palDeveloppers.ane.maps.MapEvent")]
	[Event(name="mapLoadError", type="com.palDeveloppers.ane.maps.MapEvent")]
	[Event(name="regionChange", type="com.palDeveloppers.ane.maps.MapEvent")]
	[Event(name="regionChanged", type="com.palDeveloppers.ane.maps.MapEvent")]
	[Event(name="userLocationFailed", type="com.palDeveloppers.ane.maps.MapLocationEvent")]
	[Event(name="userLocationUpdated", type="com.palDeveloppers.ane.maps.MapLocationEvent")]
	[Event(name="markerSelect", type="com.palDeveloppers.ane.maps.MapMouseEvent")]
	[Event(name="markerDeselect", type="com.palDeveloppers.ane.maps.MapMouseEvent")]
	[Event(name="infoButtonClicked", type="com.palDeveloppers.ane.maps.MapMouseEvent")]
	[Event(name="mapLongPress", type="com.palDeveloppers.ane.maps.MapMouseEvent")]
	[Event(name="mapTap", type="com.palDeveloppers.ane.maps.MapMouseEvent")]
	public class Map extends EventDispatcher
	{
		private var _visible:Boolean;
		private var _viewPort:Rectangle;
		private var _showUserLocation:Boolean;
		private var _annotationsVector:Vector.<Marker>;
		private var _overlaysVector:Vector.<Polyline>;
		
		private var extContext:ExtensionContext;
		
		public function Map()
		{
			super();
			extContext = ExtensionContext.createExtensionContext("com.palDeveloppers.ane.NativeMaps", "iMaps");
			extContext.addEventListener(StatusEvent.STATUS, statusHandler);
			extContext.call("createMapView");
			
			//Setting the default properties
			_viewPort = extContext.call("getViewPort") as Rectangle;
			_visible = false;
			_showUserLocation = false;
			
			_annotationsVector = new Vector.<Marker>();
			_overlaysVector = new Vector.<Polyline>();
		}
		
		public static function isSupported():Boolean
		{
			return Capabilities.os.toLowerCase().indexOf("ip") > -1;
		}
		
		map_internal function get context():ExtensionContext
		{
			return extContext; 
		}
		
		private function statusHandler(se:StatusEvent):void
		{
			var _marker:Marker;
			
			trace("\tCode:",se.code,"\n\tLevel:",se.level);
			if (se.code == "PIN_SELECTED")
			{
				_marker = getMarkerFromId(int(se.level));
				this.dispatchEvent(new MapMouseEvent(MapMouseEvent.MARKER_SELECT, _marker));
			}
			else if (se.code == "PIN_DESELECTED")
			{
				_marker = getMarkerFromId(int(se.level));
				this.dispatchEvent(new MapMouseEvent(MapMouseEvent.MARKER_DESELECT, _marker));
			}
			else if (se.code == "WillStartLoadingMap")
			{
				this.dispatchEvent(new MapEvent(MapEvent.TILES_LOADED_PENDING));
				trace("Loading Tiles");
			}
			else if (se.code == "DidFinishLoadingMap")
			{
				this.dispatchEvent(new MapEvent(MapEvent.TILES_LOADED));
				trace("Tiles Loaded");
			}
			else if (se.code == "DidFailLoadingMap")
			{
				this.dispatchEvent(new MapEvent(MapEvent.MAP_LOAD_ERROR));
				trace("Map Loading Error");
			}
			else if (se.code == "INFO_BUTTON_CLICKED")
			{
				_marker = getMarkerFromId(int(se.level));
				this.dispatchEvent(new MapMouseEvent(MapMouseEvent.INFO_BUTTON_CLICKED, _marker));
			}
			else if (se.code == "LOCATION_ERROR")
			{
				var errorXml:XML = new XML(se.level);
				var error:MapError = new MapError(errorXml.desc, int(errorXml.code));
				
				this.dispatchEvent(new MapLocationEvent(MapLocationEvent.USER_LOCATION_FAILED, error));
			}
			else if (se.code == "LOCATION_UPDATED")
			{
				var plainCoordinate:Object = JSON.parse(se.level);
				var coordinate:LatLng = new LatLng(plainCoordinate.lat, plainCoordinate.lng);
				
				this.dispatchEvent(new MapLocationEvent(MapLocationEvent.USER_LOCATION_UPDATED, coordinate));
			}
			else if (se.code == "REGION_CHANGE")
			{
				this.dispatchEvent(new MapEvent(MapEvent.REGION_CHANGE));
			}
			else if (se.code == "REGION_CHANGED")
			{
				this.dispatchEvent(new MapEvent(MapEvent.REGION_CHANGED));
			}
			else if (se.code == "MAP_TAP")
			{
				plainCoordinate = JSON.parse(se.level);
				coordinate = new LatLng(plainCoordinate.lat, plainCoordinate.lng);
				
				this.dispatchEvent(new MapMouseEvent(MapMouseEvent.MAP_TAP, coordinate));
			}
			else if (se.code == "MAP_LONG_PRESS")
			{
				plainCoordinate = JSON.parse(se.level);
				coordinate = new LatLng(plainCoordinate.lat, plainCoordinate.lng);
				
				this.dispatchEvent(new MapMouseEvent(MapMouseEvent.MAP_LONG_PRESS, coordinate));
			}
			else
				trace("Unrecognized Error got dispatched from Native Extnesion");
		}
		
		private function getMarkerFromId(markerId:int):Marker
		{
			for each (var _marker:Marker in _annotationsVector) {
				if (_marker.id == markerId) {
					return _marker;
				}
			}
			return null;
		}
		
		private function getOverlayFromId(overlayId:int):Polyline
		{
			for each (var _polyline:Polyline in _overlaysVector) {
				if (_polyline.id == overlayId) {
					return _polyline;
				}
			}
			return null;
		}
		
		/********** New Action Script APIs that doesnt exist in Google Maps, but required for adding/removing/modification on stage**************/
		
		public function get visible():Boolean
		{
			return _visible;
		}
		
		public function set visible(newValue:Boolean):void
		{
			if(newValue == true)
				extContext.call("showMapView");
			else
				extContext.call("hideMapView");
			_visible = newValue;
		}
		
		public function get viewPort():Rectangle
		{
			_viewPort = extContext.call("getViewPort") as Rectangle;
			return _viewPort;
		}
		
		public function set viewPort(newRect:Rectangle):void
		{
			_viewPort = newRect;
			extContext.call("setViewPort", _viewPort);
		}
		
		//Disposes of the Map object
		public function dispose():void
		{
			extContext.dispose();
		}
		
		/************ Writing Action Script APIs similar in signature to what Google Maps for Flash offers so that minimal change in code is required for reuse ***********/
		public function getSize():Point
		{
			return new Point(_viewPort.width, _viewPort.height);	
		}
		
		public function setSize(newSize:Point):void
		{
			_viewPort.width = newSize.x;
			_viewPort.height = newSize.y;
			extContext.call("setViewPort", _viewPort);
		}
		
		public function getCenter():LatLng
		{
			var mapCenter:LatLng = extContext.call("getCenter") as LatLng;
			return mapCenter;
		}
		
		public function setCenter(newCenter:LatLng):void
		{
			if (newCenter.lat() < 89.9999 && newCenter.lat() > -89.99 && newCenter.lng() < 180.0 && newCenter.lng() > -180.0)
				extContext.call("setCenter", newCenter);
			else
				throw new Error("Latitude and Longitude should be between (-90,90) and [-180,180]", 1508);
			
			//Latitude can have a value of -90 and 90 but iOS crashes application on setting the map latitude to -90 or 90 
			//Please contact me [meetshah at adobe.com] if you find a solution to this
		}
		
		public function getRegion():LatLngRegion
		{
			return extContext.call("getRegion") as LatLngRegion;
		}
		
		public function getZoom():Number
		{
			return extContext.call("getZoom") as Number;
		}
		
		public function setZoom(newZoomLevel:Number):void
		{
			extContext.call("setZoom", newZoomLevel);
		}
		
		public function panTo(newCenter:LatLng):void
		{
			if (newCenter.lat() < 89.9999 && newCenter.lat() > -89.99 && newCenter.lng() < 180.0 && newCenter.lng() > -180.0)
				extContext.call("setCenter", newCenter);
			else
				throw new Error("Latitude and Longitude should be between (-90,90) and [-180,180]",1508);
			
			//Latitude can have a value of -90 and 90 but iOS crashes application on setting the map latitude to -90 or 90 
			//Please contact me [meetshah at adobe.com] if you find a solution to this
		}
		
		public function coordinateToPoint(value:LatLng):Point
		{
			return extContext.call("coordinateToPoint", value) as Point;
		}
		
		public function pointToCoordinate(value:Point):LatLng
		{
			return extContext.call("pointToCoordinate", value) as LatLng;
		}
		
		public function addOverlay(overlay:Object):void
		{
			if (overlay is Marker)
			{
				var marker:Marker = Marker(overlay);
				_annotationsVector[_annotationsVector.length] = marker;
				marker.map_internal::owner = this;
				extContext.call("addOverlay", overlay);
			}
			else if (overlay is Polyline)
			{
				_overlaysVector[_overlaysVector.length] = Polyline(overlay);
				extContext.call("addPolyline", overlay);
			}
			
		}
		
		public function removeOverlay(overlay:Object):void
		{
			var overlayIndex:int;
			if (overlay is Marker)
			{
				overlayIndex = _annotationsVector.indexOf(overlay);
				if (overlayIndex > -1) {
					_annotationsVector.slice(overlayIndex, 1);
					extContext.call("removeOverlay", overlay);
				}
			}
			else if(overlay is Polyline)
			{
				overlayIndex = _overlaysVector.indexOf(overlay);
				if (overlayIndex > -1) {
					_overlaysVector.slice(overlayIndex, 1);
					extContext.call("removePolyline", overlay);
				}
			}
		}
		
		public function clearMap():void
		{
			extContext.call("clearMap");
			_annotationsVector = new Vector.<Marker>(); 
			_overlaysVector = new Vector.<Polyline>();
		}
		
		public function setMapType(mapType:int):void
		{
			if (mapType < 0 || mapType > 2)
				throw new Error("Unsupported Map Type By Native Extension", 8001);
			else
				extContext.call("setMapType", mapType);
		}
		
		public function drawViewPortToBitmapData(bitmapData:BitmapData):void
		{
			var validCall:Boolean = true;
			if (!bitmapData)
			{
				throw new Error("Null object reference : BitmapData is null", 1009);
				validCall = false;
			}
			if (!visible)
			{
				throw new Error("Mapview must be on stage before call to drawViewPortToBitmapData", 8002);
				validCall = false;
			}
			
			if(validCall)
				extContext.call("drawViewPortToBitmapData", bitmapData);
			else
				return;
			
		}
		
		public function set showUserLocation(shouldShow:Boolean):void
		{
			_showUserLocation = shouldShow;
			extContext.call("showUserLocation", shouldShow);
		}
		
		public function get showUserLocation():Boolean
		{
			return _showUserLocation;
		}
		
		public function zoomToRect(param1:LatLng, param2:LatLng):void
		{
			var _rect:Rectangle = new Rectangle(param1.lat(), param1.lng(), param2.lat(), param2.lng());
			extContext.call("zoomToRect", _rect);
		}
		
		public function getUserTrackingMode():int
		{
			return int(extContext.call("getUserTrackingMode"));
		}
		
		public function setUserTrackingMode(mode:int, animated:Boolean):void
		{
			extContext.call("setUserTrackingMode", mode, animated);
		}
		
		public function getUserLocation():LatLng
		{
			return extContext.call("getUserLocation") as LatLng;
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			if (type == MapLocationEvent.USER_LOCATION_UPDATED)
			{
				if (!hasEventListener(MapLocationEvent.USER_LOCATION_UPDATED))
					extContext.call("dispatchLocationUpdatedEnable", 1);
			}
			else if (type == MapEvent.REGION_CHANGE)
			{
				if (!hasEventListener(MapEvent.REGION_CHANGE))
					extContext.call("dispatchRegionChangeEnable", 1);
			}
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			super.removeEventListener(type, listener, useCapture);
			if (type == MapLocationEvent.USER_LOCATION_UPDATED)
			{
				if (!hasEventListener(MapLocationEvent.USER_LOCATION_UPDATED))
					extContext.call("dispatchLocationUpdatedEnable", 0);
			}
			else if (type == MapEvent.REGION_CHANGE)
			{
				if (!hasEventListener(MapEvent.REGION_CHANGE))
					extContext.call("dispatchRegionChangeEnable", 0);
			}
		}
	}
}