import { utils } from "./utils";

export const App: Record<string, Function> = {
  "exitApp": (): Promise<ESObject> => {
    return new Promise(resolve => {
      utils.getContext()?.terminateSelf();
      resolve(true)
    })
  },
};
