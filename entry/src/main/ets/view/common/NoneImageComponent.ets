@Component
export default struct NoneImageComponent {
  build() {
    Column() {
      Image($r("app.media.none"))
        .width(200)
        .height(200)
        .margin({ bottom: 30, top: 30})
      Text("空空如也")
    }
    .alignItems(HorizontalAlign.Center)
  }
}