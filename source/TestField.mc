import Toybox.Lang;
import Toybox.Activity;
import Toybox.Time;
import Toybox.WatchUi;
import Toybox.System;

class TestField extends WatchUi.SimpleDataField {
    public function initialize() {
        SimpleDataField.initialize();
        label = "Test";
    }

    public function compute(info as Activity.Info) as Lang.Numeric or Time.Duration or Lang.String or Null {
        var t = System.getClockTime();
        return t.hour.format("%02d") + ":" + t.min.format("%02d") + ":" + t.sec.format("%02d");
    }
}
