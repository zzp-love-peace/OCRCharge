@Preview
@CustomDialog
export default struct LoadingDialog {
  message: string | null
  controller: CustomDialogController

  build() {
    Column() {
      LoadingProgress().width(30).height(30).color(Color.White)
      Text(this.message ?? '请稍候')
        .fontColor(Color.White)
        .fontSize(16)
        .margin({ top: 15 })
        .textAlign(TextAlign.Center)
    }
    .justifyContent(FlexAlign.Center)
    .width(100)
    .height(100)
    .backgroundColor('#88000000')
    .borderRadius(8)
    .margin({ top: 50, bottom: 50 })
  }
}