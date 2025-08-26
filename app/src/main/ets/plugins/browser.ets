import Want from "@ohos.app.ability.Want";
import { utils } from "./utils";

export const Browser: Record<string, Function> = {
  "openInSystemBrowser": (options: ESObject): Promise<ESObject> => {
    return new Promise(resolve => {
      let url: string = options['url']
      let want: Want = {
        action: "ohos.want.action.viewData",
        bundleName: 'com.huawei.hmos.browser',
        abilityName: 'MainAbility',
        uri: url,
      };
      utils.getContext()?.startAbility(want);
      resolve(true)
    })
  },
};
