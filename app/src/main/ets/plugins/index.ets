import { preference } from "./preference"
import { http } from "./http";
import { updater } from "./updater";
import { Browser } from "./browser";
import { App } from "./app";
import { GeoLocation } from "./geolocation";

const classMethodMap: Record<string, Record<string, Function>> = {
  "preference": preference,
  "http": http,
  "updater": updater,
  "browser": Browser,
  "app": App,
  "geoLocation": GeoLocation
};

class Bridge {
  call(module: string, method: string, options: ESObject): ESObject {
    const moduleClass = classMethodMap[module];
    if (!moduleClass) {
      return Promise.reject(`Class ${module} not found`)
    }
    const func = moduleClass[method];
    if (!func) {
      return Promise.reject(new Error(`Function ${func} not found`))
    }
    return func(options)
  }
}

const bridge = new Bridge()

export default bridge