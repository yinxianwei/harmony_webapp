import dataPreferences from '@ohos.data.preferences';
import { VERSION_NAME } from 'BuildProfile';
import { BusinessError, request, zlib } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { fileUri, picker } from '@kit.CoreFileKit';
import { fileIo as fs } from '@kit.CoreFileKit';
import { taskpool } from '@kit.ArkTS';
import { utils } from './utils';

export const appInfoConfig = dataPreferences.getPreferencesSync(utils.getContext(), { name: 'y_appinfo' });

export const updater: Record<string, Function> = {
  "appInfo": (): Promise<ESObject> => {
    return new Promise((resolve) => {
      const info: Record<string, ESObject> = {
        "version": VERSION_NAME
      }
      resolve(info)
    })
  },
  "getVersion": (): Promise<ESObject> => {
    return new Promise((resolve) => {
      resolve(appInfoConfig.getSync("version", ""))
    })
  },
  "download": (options: ESObject): Promise<ESObject> => {
    return new Promise((resolve, reject) => {
      let context = utils.getContext() as common.UIAbilityContext;
      let url: string = options['url'];
      let version: string = options['version'];
      let progressFunc: (receivedSize: number, totalSize: number) => void = options['onProgress']
      let targetPath = context.filesDir + `/${version}`;
      let filePath = context.tempDir + `/${version}.zip`;
      if (fs.accessSync(targetPath)) {
        fs.rmdirSync(targetPath)
      }
      if (fs.accessSync(filePath)) {
        fs.unlinkSync(filePath)
      }
      if (fs.accessSync(targetPath)) {
        resolve(true)
      } else {
        fs.mkdirSync(targetPath)
        try {
          request.downloadFile(context,
            { url: url, filePath: filePath })
            .then((downloadTask: request.DownloadTask) => {
              downloadTask.on('complete', () => {
                zlib.decompressFile(filePath, targetPath).then(res => {
                  appInfoConfig.putSync("version", version);
                  appInfoConfig.flush()
                  resolve({ version });
                }).catch((err: Error) => {
                  reject(err)
                })
              })
              if (progressFunc) {
                downloadTask.on('progress', progressFunc)
              }
            }).catch((err: BusinessError) => {
            console.error(`Failed to request the download. Code: ${err.code}, message: ${err.message}`);
            reject(err)
          })
        } catch (err) {
          reject(err)
          console.error(`Failed to request the download. err: ${JSON.stringify(err)}`);
        }

      }
    });
  },
  "set": (options: ESObject): Promise<ESObject> => {
    return new Promise((resolve) => {
      let version: string = options['version'] || VERSION_NAME
      let target = `${utils.getContext()!.filesDir}/${version}`;
      utils.loadUrl(utils.getWebview()!, target);
      resolve(true)
    })
  },
  "reload": (options: ESObject) => {
  }
};