import { abilityAccessCtrl, bundleManager, Permissions } from '@kit.AbilityKit';
import { geoLocationManager } from '@kit.LocationKit';

export class Plugin {
  public webview?: WebviewController;
  public context?: Context;
  private _manager?: abilityAccessCtrl.AtManager

  get manager() {
    if (!this._manager) {
      this._manager = abilityAccessCtrl.createAtManager();
    }
    return this._manager;
  }

  constructor() {
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

  static methodList(): Array<string> {
    return [
      'getCurrentPosition'
    ]
  }
}