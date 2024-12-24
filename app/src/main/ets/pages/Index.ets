import { webview } from '@kit.ArkWeb'

@Entry
@Component
struct Index {
  controller: webview.WebviewController = new webview.WebviewController();
  baseUrl: string = 'https://www.example.com/';
  responseWeb: WebResourceResponse = new WebResourceResponse();

  build() {
    Column() {
      Web({
        src: this.baseUrl,
        controller: this.controller,
      })
        .fileAccess(true)
        .mixedMode(MixedMode.All)
        .domStorageAccess(true).onInterceptRequest((event) => {
        const url = event.request.getRequestUrl();
        if (url.indexOf(this.baseUrl) == 0) {
          let filename = url.replace(this.baseUrl, '') || 'index.html';
          this.responseWeb.setResponseData($rawfile(filename));
          this.responseWeb.setResponseCode(200);
          if (filename.endsWith('.html')) {
            this.responseWeb.setResponseMimeType('text/html');
          } else if (filename.endsWith('.css')) {
            this.responseWeb.setResponseMimeType('text/css');
          } else if (filename.endsWith('.js')) {
            this.responseWeb.setResponseMimeType('application/javascript');
          }
        }
        return this.responseWeb;
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