import Toybox.Activity;
import Toybox.Application;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

(:background)
class TestApp extends Application.AppBase {
    (:background)
    var isForeground as Boolean;

    (:background)
    function initialize() {
		// TODO: can it be removed?
        AppBase.initialize();

        var isForeground = !isRunningInBackground();
        self.isForeground = isForeground;

        log("TestApp.initialize: " + isForeground);
    }

    (:background)
    public function onAppInstall() as Void {
        log("TestApp.onAppInstall");
        Stats.onAppInstall();
    }

    (:background)
    public function onAppUpdate() as Void {
        log("TestApp.onAppUpdate");
        Stats.onAppUpdate();
    }

    (:background, :typecheck(disableBackgroundCheck))
    public function onStart(state as Dictionary?) as Void {
        log("TestApp.onStart: " + isForeground);
        if (self.isForeground) {
            Stats.onStart();
        }
    }

    (:typecheck(disableBackgroundCheck), :background)
    public function onStop(state as Dictionary?) as Void {
        log("TestApp.onStop: " + isForeground + "; " + state);
        if (isForeground) {
            Stats.onStop();
        }
    }

    (:typecheck(disableBackgroundCheck))
    public function getInitialView() as Array<Views or InputDelegates> or Null {
        log("TestApp.getInitialView");
        return [ new TestField() ] as Array<View or InputDelegates>;
    }

    (:background)
    public function getServiceDelegate() as Array<ServiceDelegate> {
        // self.isBackground = true;
    	log("TestApp.getServiceDelegate");
    	return [ new StatsServiceDelegate() ] as Array<ServiceDelegate>;
    }

    (:background)
    public function onValidateProperty(key as Lang.String, value as PropertyValueType) as Lang.Boolean or Lang.String {
        log("TestApp.onValidateProperty: " + key + " = " + value);
        return true;
    }

    (:background)
    public function onStorageChanged() as Void {
        log("TestApp.onStorageChanged: " + isForeground);
        if (!isForeground) {
            Stats.onStorageChanged();
        }
    }

    (:typecheck(disableBackgroundCheck))
    public function onBackgroundData(responseData as Application.PersistableType) as Void {
        //only runs in FG
        log("TestApp.onBackgroundData !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!: " + responseData);
        Stats.onBackgroundData(responseData);
    }

}
