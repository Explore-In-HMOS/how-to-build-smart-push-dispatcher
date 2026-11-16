@Component
export struct NavigationButton {
  @Prop title: string

  build() {
    Button(this.title)
      .width('95%')
      .fontSize(14)
      .fontColor('#fffcf2')
      .backgroundColor('#0077b6')
      .borderRadius(5)
  }
}