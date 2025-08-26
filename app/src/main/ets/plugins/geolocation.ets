import { geoLocationManager } from '@kit.LocationKit';
import { utils } from './utils';

export const GeoLocation: Record<string, Function> = {
  "isLocationEnabled": (options: ESObject): Promise<ESObject> => {
    return new Promise((resolve, reject) => {
      try {
        let locationEnabled = geoLocationManager.isLocationEnabled();
        resolve({ value: locationEnabled })
      } catch (err) {
        reject(err)
      }
    })
  },
  "checkPermissions": (options: ESObject): ESObject => {
    return utils.checkPermissions(['ohos.permission.APPROXIMATELY_LOCATION', 'ohos.permission.LOCATION'])
  },
  "requestPermissions": (options: ESObject): ESObject => {
    return utils.requestPermissions(['ohos.permission.APPROXIMATELY_LOCATION', 'ohos.permission.LOCATION'])
  },
  "getCurrentPosition": (options: ESObject = {}): ESObject => {
    let timeout: number = options['timeout'] || 5000
    let enableHighAccuracy: boolean = options['enableHighAccuracy'] || false
    let request: geoLocationManager.SingleLocationRequest = {
      'locatingPriority': enableHighAccuracy ? geoLocationManager.LocatingPriority.PRIORITY_ACCURACY :
      geoLocationManager.LocatingPriority.PRIORITY_LOCATING_SPEED,
      'locatingTimeoutMs': timeout
    }
    return geoLocationManager.getCurrentLocation(request);
  }
};
