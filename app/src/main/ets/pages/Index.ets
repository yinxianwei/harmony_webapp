import { webview } from '@kit.ArkWeb'
import { BusinessError } from '@kit.BasicServicesKit';
import { utils } from '../plugins/utils';
import bridge from '../plugins';
import { updater } from '../plugins/updater';
import { VERSION_NAME, DEBUG } from 'BuildProfile';

@Entry
@Component
struct Index {
  controller: webview.WebviewController = utils.getWebview()!
  targetDir: string = utils.getContext()!.filesDir + '/' + VERSION_NAME

  aboutToAppear(): void {
    webview.WebviewController.setWebDebuggingAccess(DEBUG);
    let srcDir = utils.getContext()!.resourceDir + '/dist/';
    utils.copyFiles(srcDir, this.targetDir, DEBUG)
  }

  build() {
    Column() {
      Web({
        src: "",
        controller: this.controller
      })
        .onControllerAttached(async () => {
          try {
            let version: string = await updater['getVersion']();
            if (utils.compareVersion(VERSION_NAME, version) == -1) {
              this.targetDir = utils.getContext()!.filesDir + '/' + version + '/'
            }
            utils.loadUrl(this.controller, this.targetDir)
          } catch (error) {
            console.error(`ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
          }
        })
        .javaScriptProxy({
          name: 'harmony',
          object: bridge,
          controller: this.controller,
          methodList: ['call'],
          asyncMethodList: []
        })
        .javaScriptAccess(true)
        .fileAccess(true)
        .mixedMode(MixedMode.All)
        .domStorageAccess(true)
        .onAlert(event => {
          this.getUIContext().showAlertDialog({
            title: '温馨提示',
            message: event.message,
            primaryButton: {
              value: '取消',
              action: () => {
                event.result.handleCancel()
              }
            },
            secondaryButton: {
              value: '确定',
              action: () => {
                event.result.handleConfirm()
              }
            },
            cancel: () => {
              event.result.handleCancel()
            }
          })
          return true
        })
        .geolocationAccess(true)
        .onGeolocationShow(async (event) => {
          try {
            await utils.requestPermissions(['ohos.permission.APPROXIMATELY_LOCATION', 'ohos.permission.LOCATION'])
          } catch (e) {
          }
          this.getUIContext().showAlertDialog({
            title: '位置权限请求',
            message: '是否允许获取位置信息',
            primaryButton: {
              value: '取消',
              action: () => {
                if (event) {
                  event.geolocation.invoke(event.origin, false, false);
                }
              }
            },
            secondaryButton: {
              value: '确定',
              action: () => {
                if (event) {
                  event.geolocation.invoke(event.origin, true, true);
                }
              }
            },
            cancel: () => {
              if (event) {
                event.geolocation.invoke(event.origin, false, false);
              }
            }
          })
        })
    }
  }

  onBackPress() {
    if (this.controller.accessStep(-1)) {
      this.controller.backward();
      return true;
    } else {
      return false;
    }
  }
}