package com.palDeveloppers.ane.maps
{
	public class MapError
	{
		private var _description:String;
		private var _code:int;
		
		public function MapError(description:String, code:int)
		{
			_description = description;
			_code = code;
		}
		
		public function get description():String
		{
			return _description;
		}
		
		public function get code():int
		{
			return _code;
		}
	}
}