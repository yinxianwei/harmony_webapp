import fs from '@ohos.file.fs';
import { BusinessError } from '@kit.BasicServicesKit';
import { webview } from '@kit.ArkWeb'
import { abilityAccessCtrl, bundleManager, common, Permissions, PermissionRequestResult } from '@kit.AbilityKit';

export class GlobalThis {
  private constructor() {
  };

  private static instance: GlobalThis;
  private context?: common.UIAbilityContext;
  private UIContext?: common.UIAbilityContext;
  private webview?: webview.WebviewController;

  static getInstance(): GlobalThis {
    if (!GlobalThis.instance) {
      GlobalThis.instance = new GlobalThis();
    }
    return GlobalThis.instance;
  }

  getContext(): common.UIAbilityContext | undefined {
    return this.context
  }

  setContext(context: common.UIAbilityContext) {
    this.context = context;
  }

  getUIContext(): common.UIAbilityContext | undefined {
    return this.UIContext
  }

  setUIContext(context: common.UIAbilityContext) {
    this.UIContext = context;
  }


  getWebview(): webview.WebviewController | undefined {
    return this.webview
  }

  setWebview(webview: webview.WebviewController) {
    this.webview = webview;
  }
}


export class utils {
  static getContext() {
    return GlobalThis.getInstance().getContext()
  }

  static getWebview() {
    return GlobalThis.getInstance().getWebview();
  }

  static copyFiles(srcDir: string, targetDir: string, force: boolean) {
    if (force && fs.accessSync(targetDir)) {
      fs.rmdirSync(targetDir)
    }
    if (!fs.accessSync(targetDir)) {
      fs.mkdirSync(targetDir)
      fs.copyDirSync(srcDir, targetDir, 0);
    }
  }

  static loadUrl(webview: webview.WebviewController, targetDir: string) {
    webview.setPathAllowingUniversalAccess([
      targetDir,
      targetDir + "/css",
      targetDir + "/js",
      targetDir + "/assets"
    ])
    webview.loadUrl(targetDir + '/index.html')
  }

  static compareVersion(v1: string, v2: string): number {
    let parts1: number[] = v1.split('.').map(Number);
    let parts2: number[] = v2.split('.').map(Number);
    let len: number = Math.max(parts1.length, parts2.length);

    for (let i = 0; i < len; i++) {
      let num1: number = parts1[i] ?? 0;
      let num2: number = parts2[i] ?? 0;

      if (num1 > num2) {
        return 1;
      } else if (num1 < num2) {
        return -1;
      }
    }
    return 0;
  }

  static async checkPermissions(permissions: Array<Permissions>): Promise<boolean> {
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    let tokenId: number = 0;
    try {

      let bundleInfo: bundleManager.BundleInfo =
        await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
      let appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo;
      tokenId = appInfo.accessTokenId;
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      console.error(`Failed to get bundle info for self. Code is ${err.code}, message is ${err.message}`);
      return false
    }
    let promises: Array<Promise<abilityAccessCtrl.GrantStatus>> = []
    permissions.forEach(permission => {
      promises.push(atManager.checkAccessToken(tokenId, permission))
    })
    try {
      let res = await Promise.all(promises);
      return res.findIndex(val => val == abilityAccessCtrl.GrantStatus.PERMISSION_DENIED) == -1
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      console.error(`Failed to check access token. Code is ${err.code}, message is ${err.message}`);
    }
    return false
  }

  static async requestPermissions(permissions: Array<Permissions>): Promise<boolean> {
    return new Promise((resolve, reject) => {
      let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
      atManager.requestPermissionsFromUser(GlobalThis.getInstance().getContext(), permissions).then(res => {
        resolve(res.authResults.findIndex(val => val == -1) == -1)
      }).catch((err: BusinessError) => {
        reject(err)
      })
    })
  }
}