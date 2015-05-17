Adobe AIR ANE for iOS devices that allows developer to use the native system maps.

All base code is taken from [AIR Maps ANE](https://code.google.com/p/air-maps-ane/) so credit goes to its author. The old ANE however had several issues and features that were needed, and the author has seemed unable to look into it. Main changes and improvements over the old one:

  * Simulator and Android platforms added so compilation and testing can be made easier. Just wrap your main code inside a Map.isSupported() check.
  * Fixed app crash when clicking on current user location.
  * Fixed garbled characters in markers text.
  * User tracking mode can be set.
  * User location can be obtained from map.
  * Markers now may have a details button, enable it through marker.showInfoWindowButton, and listen for MapMouseEvent.INFO\_BUTTON\_CLICKED in your Map instance.
  * Added two new events for user location: MapLocationEvent.USER\_LOCATION\_FAILED and MapLocationEvent.USER\_LOCATION\_UPDATED.
  * Several more features.

ANE developed for [PalDeveloppers](http://www.paldeveloppers.com).