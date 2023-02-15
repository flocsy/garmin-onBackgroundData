import Toybox.System;

(:background, :background_app)
class StatsServiceDelegate extends System.ServiceDelegate {

	function initialize() {
		// TODO: can it be removed?
		ServiceDelegate.initialize();
		log("StatsServiceDelegate.initialize");
	}
	
	function onTemporalEvent() as Void {
		log("StatsServiceDelegate.onTemporalEvent");
		Stats.onTemporalEvent();
	}
}
