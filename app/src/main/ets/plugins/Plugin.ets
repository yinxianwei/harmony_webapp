import { abilityAccessCtrl, bundleManager, common, Permissions } from '@kit.AbilityKit';
import { geoLocationManager } from '@kit.LocationKit';
import { CallBackMsg, JPushInterface } from '@jg/push';
import { JPushCallBackMsg } from './JPushCallBackMsg';
import { notificationManager } from '@kit.NotificationKit';

export class Plugin {
  public context: common.UIAbilityContext;
  public webview?: WebviewController;
  private _manager?: abilityAccessCtrl.AtManager
  eventListeners: Map<string, Array<Function>>;

  get manager() {
    if (!this._manager) {
      this._manager = abilityAccessCtrl.createAtManager();
    }
    return this._manager;
  }

  constructor(context: common.UIAbilityContext) {
    this.context = context;
    this.eventListeners = new Map()
  }

  addListener(key: string, callback: Function) {
    if (this.eventListeners[key]) {
      this.eventListeners[key].push(callback)
    } else {
      this.eventListeners.set(key, [callback])
    }
  }

  removeListener(key: string, callback: Function) {
    let listeners = this.eventListeners.get(key);
    if (listeners) {
      this.eventListeners.set(key, listeners.filter(call => call != callback));
    }
  }

  notifyListeners(key: string, data: object) {
    let listenersForEvent = this.eventListeners.get(key);
    if (listenersForEvent) {
      listenersForEvent.forEach(call => {
        call(data)
      })
    }
  }

  removeAllListeners() {
    this.eventListeners.clear()
  }

  getAccessTokenID() {
    let tokenId: number = 0;
    let bundleInfo: bundleManager.BundleInfo =
      bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
    let appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo;
    tokenId = appInfo.accessTokenId;
    return tokenId;
  }

  checkPermissions(permissions: Array<Permissions>): Promise<boolean> {
    return new Promise((resolve, reject) => {
      let tokenID = this.getAccessTokenID()
      let promises = permissions.map(permission => {
        return this.manager.checkAccessToken(tokenID, permission)
      })
      Promise.all(promises).then(statusList => {
        if (statusList.find(val => val == abilityAccessCtrl.GrantStatus.PERMISSION_DENIED)) {
          resolve(false);
        } else {
          resolve(true)
        }
      })
    })
  }

  requestPermissions(permissions: Array<Permissions>): Promise<boolean> {
    return new Promise((resolve, reject) => {
      this.manager.requestPermissionsFromUser(this.context, permissions).then((res) => {
        if (res.authResults.find(val => val != 0)) {
          resolve(false)
        } else {
          resolve(true);
        }
      }).catch(() => {
        resolve(false)
      })
    })
  }

  async getCurrentPosition(success: Function, error: Function, options: object = Object({})) {
    let hasPermission =
      await this.requestPermissions(['ohos.permission.LOCATION', 'ohos.permission.APPROXIMATELY_LOCATION'])
    if (!hasPermission) {
      error && error();
      return;
    }
    let requestInfo: geoLocationManager.CurrentLocationRequest = {
      timeoutMs: options['timeout'] || 10000,
      'priority': geoLocationManager.LocationRequestPriority.FIRST_FIX,
      'scenario': geoLocationManager.LocationRequestScenario.UNSET,
      'maxAccuracy': options['maxAccuracy'] || 0
    };
    geoLocationManager.getCurrentLocation(requestInfo).then(location => {
      success && success({
        timestamp: location.timeStamp,
        coords: location
      })
    }, (e: Error) => {
      error && error(e)
    })
  }

  JPushInit(options: object): Promise<boolean> {
    return new Promise(async (resolve, reject) => {
      let isEnabled = notificationManager.isNotificationEnabledSync();
      if (!isEnabled) {
        try {
          await notificationManager.requestEnableNotification(this.context)
        } catch (e) {
          return reject(e)
        }
      }
      let callback = new JPushCallBackMsg(this.context.getApplicationContext(), this);
      JPushInterface.setCallBackMsg(callback)
      JPushInterface.setAppKey(options['appKey']);
      JPushInterface.setChannel(options['channel']);
      JPushInterface.init(this.context)
      resolve(true)
    })
  }

  JPushGetRegistrationId(): Promise<string> {
    return new Promise((resolve, reject) => {
      let rid = JPushInterface.getRegistrationId()
      resolve(rid)
    })
  }

  static methodList(): Array<string> {
    return [
      'getCurrentPosition',
      'JPushInit',
      'JPushGetRegistrationId',
      'addListener',
      'removeListener',
      'removeAllListeners',
    ]
  }
}