@Builder
export function JWTBuilder() {
  JWT()
}

@Entry
@Component
export struct JWT {
  @Consume('mainStack') pathStack: NavPathStack;
  private scroller: Scroller = new Scroller()
  @State jwt: string = ''

  aboutToAppear() {
    const params = this.pathStack.getParamByName('JWT') as Object[]
    this.jwt = params[0] as string
  }

  build() {
    NavDestination() {
      Column() {
        Text('JWT Token: ').padding({ bottom: 15, top: 10 }).fontColor(Color.Red)
        Scroll(this.scroller) {
          Text(this.jwt)
            .margin({bottom:120})
        }
      }
      .padding({ right: 15, left: 15 })
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .height('100%')
    }
    .hideBackButton(true)
  }
}