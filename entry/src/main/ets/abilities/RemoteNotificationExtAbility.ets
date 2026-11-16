import { common } from '@kit.AbilityKit';
import { image } from '@kit.ImageKit';
import { pushCommon, RemoteNotificationExtensionAbility } from '@kit.PushKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { resourceManager } from '@kit.LocalizationKit';

export default class RemoteNotificationExtAbility extends RemoteNotificationExtensionAbility {
  async onReceiveMessage(
    remoteNotificationInfo: pushCommon.RemoteNotificationInfo
  ): Promise<pushCommon.RemoteNotificationContent> {
    hilog.info(0x0000, 'testTag', 'RemoteNotificationExtAbility onReceiveMessage, remoteNotificationInfo');

    // Read the pixel map object
    const resourceMgr: resourceManager.ResourceManager = (this.context as common.UIExtensionContext).resourceManager;
    let fileData: Uint8Array = new Uint8Array(0);
    try {
      fileData = await resourceMgr.getMediaContent($r('app.media.startIcon').id);
    } catch (e) {
      hilog.error(0x0000, 'testTag', 'Failed to get media content: %{public}d %{public}s', e.code, e.message);
    }
    const buffer = fileData.buffer;
    const imageSource: image.ImageSource = image.createImageSource(buffer as ArrayBuffer);
    const pixelMap: image.PixelMap = await imageSource.createPixelMap();
    if (pixelMap) {
      pixelMap.getImageInfo((err, imageInfo) => {
        if (imageInfo) {
          hilog.info(0x0000, 'testTag', `imageInfo ${imageInfo.size.width} * ${imageInfo.size.height}`);
        }
      });
    }

    this.textToSpeech();

    // Return the display message content
    return {
      title: 'Default replace title.',
      text: 'Default replace text.',
      badgeNumber: 1,
      setBadgeNumber: 2,
      overlayIcon: pixelMap,
      wantAgent: {
        abilityName: 'DemoAbility',
        parameters: {
          key: 'Default value'
        }
      }
    }
  }

  textToSpeech(): void {
    // Perform the text-to-speech task
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', 'RemoteNotificationExtAbility onDestroy.');
  }
}