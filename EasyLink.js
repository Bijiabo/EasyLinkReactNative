import {NativeEventEmitter, NativeModules, DeviceEventEmitter} from 'react-native';
const EasyLinkModule = NativeModules.EasyLinkModule;
const EasyLinkModuleEmitter = new NativeEventEmitter(EasyLinkModule);
let EasyLinkSubscription;
let EasyLinkCallback = () => {};

/**
 * start EasyLink
 * @param ssid: string
 * @param password: string
 * @param callback: Object=>Void, the EasyLinkResult listener
 */
const start = (ssid, password, callback) => {
  console.log("[EasyLink] Start.");

  if (typeof callback === "function") {
    EasyLinkCallback = callback;
  }

  EasyLinkModule.startEasyLinkWithData({
    SSID: ssid || 'none',
    PASSWORD: password || 'none',
    DHCP: true,
  });
};

/**
 * stop EasyLink
 */
const stop = () => {
  console.log("[EasyLink] Stop.");
  EasyLinkModule.stopEasyLink();
};

/**
 * setup EasyLink data listener
 */
const setup = () => {
  EasyLinkSubscription = EasyLinkModuleEmitter.addListener(
    "EasylinkNotification",
    data => {
      console.log("[EasyLink] Data:", data);
      EasyLinkCallback(data);
    }
  );
};

setup();

export default {
  start,
  stop,
};