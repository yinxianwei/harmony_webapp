import dataPreferences from '@ohos.data.preferences';
import { utils } from './utils';

let config = dataPreferences.getPreferencesSync(utils.getContext(), { name: 'y_preferences' });

export const preference: Record<string, Function> = {
  "setValue": (options: ESObject): Promise<ESObject> => {
    return new Promise(resolve => {
      config.putSync(options.key, options.value)
      config.flush()
      resolve(true)
    })
  },
  "getValue": (options: ESObject): Promise<ESObject> => {
    return new Promise(resolve => {
      resolve(config.getSync(options.key, null))
    })
  },
  "remove": (options: ESObject): Promise<ESObject> => {
    return new Promise(resolve => {
      config.deleteSync(options.key);
      resolve(true)
    })
  },
  "clear": (): Promise<ESObject> => {
    return new Promise(resolve => {
      config.clearSync()
      resolve(true)
    })
  }
};
