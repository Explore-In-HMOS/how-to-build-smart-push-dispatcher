import { ArcScrollBar } from '@kit.ArkUI'
import { NavigationButton } from '../component/NavigationButton'
import { HomeViewModel } from '../viewmodel/HomeViewModel'

@Entry
@Component
struct Index {
  private viewModel = new HomeViewModel()
  private scroller: Scroller = new Scroller()
  @Provide('mainStack') pathStack: NavPathStack = new NavPathStack()

  build() {
    Navigation(this.pathStack) {
      Stack() {
        Scroll(this.scroller) {
          Column({ space: 20 }) {
            NavigationButton({ title: 'getToken()' }).onClick(async () => {
              let token = await this.viewModel.getPushToken()
              this.pathStack.pushPath({
                name: 'PushToken',
                param: token
              })
            })
            NavigationButton({ title: 'getAAID()' }).onClick(async () => {
              let aaid = await this.viewModel.getAAID()
              this.pathStack.pushPath({
                name: 'AAID',
                param: aaid
              })
            })
            NavigationButton({ title: 'getJWT()' }).onClick(async () => {
              const jwt = await this.viewModel.getJWT()
              this.pathStack.pushPath({
                name: 'JWT',
                param: jwt
              })
            })
            NavigationButton({ title: 'pushMessage()' }).onClick(async () => {
              const result = await this.viewModel.sendNotification('Hi', 'Wearable')
              console.info(`code: ${result.code}` + ` msg: ${result.msg}`)

              this.pathStack.pushPath({
                name: 'PushMessage',
                param: result
              })
            })
          }
          .padding(20)
          .alignItems(HorizontalAlign.Center)
        }
        .scrollBar(BarState.Off)
        .width('90%')

        ArcScrollBar({ scroller: this.scroller, state: BarState.Auto })
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#1c0000')
      .alignContent(Alignment.Center)
    }
    .hideTitleBar(true)
  }
}