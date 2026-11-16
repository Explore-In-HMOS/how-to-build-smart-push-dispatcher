@Builder
export function PushTokenBuilder() {
  PushToken()
}

@Entry
@Component
export struct PushToken {
  @Consume('mainStack') pathStack: NavPathStack;
  @State deviceToken: string = ''

  aboutToAppear() {
    const params = this.pathStack.getParamByName('PushToken') as Object[]
    this.deviceToken = params[0] as string
  }

  build() {
    NavDestination() {
      Column() {
        Text('Device token: ').padding({ bottom: 15 }).fontColor(Color.Red)
        Text(this.deviceToken)
      }
      .padding({ right: 15, left: 15 })
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .height('100%')
    }
    .hideBackButton(true)
  }
}