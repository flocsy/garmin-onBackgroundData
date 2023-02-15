import Toybox.Application;
import Toybox.Application.Properties;
import Toybox.Application.Storage;
import Toybox.Background;
import Toybox.Communications;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;
import Toybox.UserProfile;

module Stats {
    (:background) const STORAGE_KEY = "Q";

    (:background)const STATS_URL = "https://api.ipify.org";

    (:background)
    function onAppInstall() as Void {
        enqueueStats('i');
    }

    (:background)
    function onAppUpdate() as Void {
        enqueueStats('u');
    }

    public function onStart() as Void {
        enqueueStats('s');
    }

    public function onStop() as Void {
        enqueueStats('x');
    }

    (:background)
    public function onStorageChanged() as Void {
		log("Stats.onStorageChanged");
		var c = getStorageOrDefault(STORAGE_KEY, null) as Char or Null;
        if (c != null) {
            send(c as Char);
        }
    }

    (:background)
    public function onTemporalEvent() as Void {
		log("Stats.onTemporalEvent");
		var c = getStorageOrDefault(STORAGE_KEY, null) as Char or Null;
        send(c as Char);
    }

    public function onBackgroundData(responseData as Application.PersistableType) as Void {
        //only runs in FG
        log("Stats.onBackgroundData: " + responseData);
        if (responseData != null) {
            log("Stats.onBackgroundData: delete storage");
            setStorage(STORAGE_KEY, null);
        }
    }

    (:background, :typecheck(disableBackgroundCheck))
    function enqueueStats(c as Char) as Void {
        if (isRunningInBackground()) {
            send(c);
        } else {
            triggerTemporalEvent(c);
        }
    }

    function triggerTemporalEvent(data as PropertyValueType) as Void {
        setStorage(STORAGE_KEY, data);

        var lastTime = Background.getLastTemporalEventTime();
        var nextTime = lastTime != null ? lastTime.add(new Time.Duration(300)) : Time.now();
        log("Stats.triggerTemporalEvent: " + (lastTime == null ? null : timeFormat(lastTime)) + ", " + timeFormat(nextTime) + ": " + data);
        Background.registerForTemporalEvent(nextTime);
    }

    (:background)
    function send(c as Char) as Void {
        try {
            log("Stats.send: " + c);

            var url = STATS_URL;               // set the url

            var params = {
                "c" => "" + c
            };
            var options = {                                             // set the options
                :method => Communications.HTTP_REQUEST_METHOD_GET,     // set HTTP method
            };
            var responseCallback  = new Lang.Method(Stats, :onReceive) as Method(responseCode as Number, data as Dictionary or String or Null) as Void;
            Communications.makeWebRequest(url, params, options, responseCallback);
        } catch (e) {
            errorRelease("sendStats: " + e.getErrorMessage());
        }
    }

    (:background)
    function doWebRequest(url as String, params as Dictionary?,
            options as {
                :method as Communications.HttpRequestMethod, :headers as Dictionary, :responseType as Communications.HttpResponseContentType, :context as Object?,
                :maxBandwidth as Number, :fileDownloadProgressCallback as Method(totalBytesTransferred as Number, fileSize as Number?) as Void } or Null,
            responseCallback as (Method(responseCode as Number, data as Dictionary or String or Null) as Void)
                             or (Method(responseCode as Number, data as Dictionary or String or Null, context as Object) as Void)) as Void {
    }

    (:background)
    function onReceive(responseCode as Number, data as Dictionary or String or Null) as Void {
        log("Stats.onReceive: finished: " + responseCode + ' ' + data);
        log("Stats.onReceive: Background.exit: " + responseCode);
        Background.exit(responseCode);
    }
}
