import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { pushCommon, pushService } from '@kit.PushKit';
import { BusinessError } from '@kit.BasicServicesKit';

export default class PushMessageAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'PushMessageAbility onCreate');
    this.registerEvent();
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }

  private registerDefaultEvent(): void {
    try {
      pushService.receiveMessage("DEFAULT", this, (payload) => {
        hilog.info(0x0000, 'testTag', '%{public}s', 'receive message for DEFAULT type');

        try {
          // Retrieve data from server
          const data: string = payload.data;
          // TODO：process business
          hilog.info(0x0000, 'testTag', 'Succeeded in getting notification,data=%{public}s',
            JSON.stringify(JSON.parse(data)?.notification));
        } catch (err) {
          const e: BusinessError = err as BusinessError;
          hilog.error(0x0000, 'testTag', 'Failed to process data: %{public}d %{public}s', e.code, e.message);
        }
      });
      hilog.info(0x0000, 'testTag', '%{public}s', 'succeed to register default message');
    } catch (err) {
      const e: BusinessError = err as BusinessError;
      hilog.error(0x0000, 'testTag', 'Failed to register default message: %{public}d %{public}s', e.code, e.message);
    }
  }

  private registerBackgroundEvent(): void {
    try {
      pushService.receiveMessage('BACKGROUND', this, (data: pushCommon.PushPayload) => {
        hilog.info(0x0000, 'testTag', '%{public}s', 'receive message for BACKGROUND type');
        // TODO：process business
        try {
          hilog.info(0x0000, 'testTag', 'Receive background message');
        } catch (e) {
          let errRes: BusinessError = e as BusinessError;
          hilog.error(0x0000, 'testTag', 'Failed to process data: %{public}d %{public}s', errRes.code, errRes.message);
        }
      });
      hilog.info(0x0000, 'testTag', '%{public}s', 'succeed to register background message');
    } catch (err) {
      const e: BusinessError = err as BusinessError;
      hilog.error(0x0000, 'testTag', 'Failed to register background message: %{public}d %{public}s', e.code, e.message);
    }
  }

  private registerEvent(): void {
    this.registerDefaultEvent();
    this.registerBackgroundEvent();
  }
}
