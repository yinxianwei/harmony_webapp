import { CallBackMsg, JMessage } from '@jg/push';
import { common } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { Plugin } from './Plugin';

export class JPushCallBackMsg extends CallBackMsg {
  context: common.ApplicationContext
  implementation: Plugin;

  constructor(co: common.ApplicationContext, impl: Plugin) {
    super();
    this.context = co
    this.implementation = impl
  }

  onClickMessage(jMessage: JMessage): void {
    this.implementation.notifyListeners('JPushOpenNotification', jMessage)
  }
}