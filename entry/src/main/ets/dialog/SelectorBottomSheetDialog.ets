interface SelectorBottomSheetBean {
  content: string,
  action: () => void
}

@CustomDialog
export default struct SelectorBottomSheetDialog {
  title: string
  sheets: SelectorBottomSheetBean[]
  controller: CustomDialogController

  build() {
    Column() {
      Text(this.title)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 30, bottom: 20 })
      ForEach(this.sheets, (item: SelectorBottomSheetBean) => {
        Text(item.content)
          .fontSize(17)
          .fontColor(Color.Blue)
          .textAlign(TextAlign.Center)
          .margin({ left: 20, right: 20, bottom: 15 })
          .width('100%')
          .onClick(() => {
            item.action()
            this.controller.close()
          })
      })
      Button('取消')
        .onClick(() => {
          this.controller.close()
        })
        .backgroundColor($r("app.color.white"))
        .fontColor(Color.Red)
        .margin({ bottom: 12, left: 20, right: 20 })
        .width('100%')
    }
  }
}