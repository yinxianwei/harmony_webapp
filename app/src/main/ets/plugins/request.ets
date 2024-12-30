import { http } from "@kit.NetworkKit";

let implementation: http.HttpRequest;

export const request = (url: string, options: object): Promise<object> => {
  implementation = implementation || http.createHttp();
  return implementation.request(url, options);
}