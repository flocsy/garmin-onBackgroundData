import Toybox.Activity;
import Toybox.Application;
import Toybox.Application.Properties;
import Toybox.Application.Storage;
import Toybox.Background;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;

(:background) const LOG = true;
(:background) const PROPERTY_VERSION = "v";
(:background) const PROPERTY_NON_EXSISTANT = "X";

typedef AlphaNumeric as String or Number;

(:background)
function log(msg as String) as Void {
    if (LOG) {
        logRelease(msg);
    }
}

(:background)
function logRelease(msg as String) as Void {
    var time = timeFormat(Time.now());
    System.println(time + " " + msg);
}

(:background)
function errorRelease(msg as String) as Void {
    logRelease(msg);
}

(:background)
function timeFormat(moment as Moment) as AlphaNumeric {
    var time = Time.Gregorian.info(moment as Moment, Time.FORMAT_SHORT);
    return "" + time.hour + ':' + time.min + ':' + time.sec;
}


(:background)
function isRunningInBackground() as Boolean {
    try {
        Properties.setValue(PROPERTY_VERSION, "");
        return false;
    } catch (ex) {
        return true;
    }
}

(:background)
function setStorage(key as PropertyKeyType, val as PropertyValueType) as Void {
    log("setStorage: " + key + " = " + val);
    Storage.setValue(key, val);
}

(:background)
function getStorage(key as PropertyKeyType) as PropertyValueType or Null {
    var val;
    try {
        val = Storage.getValue(key);
    } catch (e) {
        errorRelease(key + ":" + e.getErrorMessage());
        val = null;
    }
    return val;
}
(:background)
function getStorageOrDefault(key as PropertyKeyType, defaultValue as PropertyValueType?) as PropertyValueType? {
    var value = getStorage(key);
    return value != null ? value : defaultValue;
}
