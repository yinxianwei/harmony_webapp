import { http as _http } from '@kit.NetworkKit';
import { url } from '@kit.ArkTS';

let httpObj = _http.createHttp();

export const http: Record<string, Function> = {
  "request": (options: ESObject) => {
    let urlObject = url.URL.parseURL(options.url);
    if (options.params) {
      Object.keys(options.params).forEach(key => {
        const value: ESObject = options.params[key];
        urlObject.params.append(key, value || value === 0 ? String(value) : '')
      })
    }
    return httpObj.request(urlObject.toString(), {
      method: options.method as _http.RequestMethod || _http.RequestMethod.GET,
      readTimeout: options.readTimeout,
      header: options.headers,
      extraData: options.data
    })
  }
};
