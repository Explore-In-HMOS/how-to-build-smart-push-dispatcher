import { PushResponse } from "../model/PushResponse";

@Builder
export function PushMessageBuilder() {
  PushMessage()
}

@Entry
@Component
export struct PushMessage {
  @Consume('mainStack') pathStack: NavPathStack;
  private result: PushResponse = { code: '', msg: '' }

  aboutToAppear() {
    const params = this.pathStack.getParamByName('PushMessage') as PushResponse[]
    if (params && params.length > 0) {
      this.result = params[0]
      console.info(`code: ${this.result.code}` + ` msg: ${this.result.msg}`)
    }
  }

  build() {
    NavDestination() {
      Column() {
        Text('Send notification msg ').padding({ bottom: 15 }).fontColor(Color.Red)
        Text(this.result.code).padding({bottom:10})
        Text(this.result.msg)
      }
      .padding({ right: 15, left: 15 })
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .height('100%')
    }
    .hideBackButton(true)
  }
}