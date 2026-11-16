@Builder
export function AAIDBuilder() {
  AAID()
}

@Entry
@Component
export struct AAID {
  @Consume('mainStack') pathStack: NavPathStack;
  @State aaid: string = ''

  aboutToAppear() {
    const params = this.pathStack.getParamByName('AAID') as Object[]
    this.aaid = params[0] as string
  }

  build() {
    NavDestination() {
      Column() {
        Text('AAID: ').padding({ bottom: 15 }).fontColor(Color.Red)
        Text(this.aaid)
      }
      .padding({ right: 15, left: 15 })
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .height('100%')
    }
    .hideBackButton(true)
  }
}