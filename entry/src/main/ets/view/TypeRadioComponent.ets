@Component
export default struct TypeRadioComponent {
  @Link isIncomeType: boolean
  onChangeListener: ((value: boolean) => void) = () => {
  }

  build() {
    Row() {
      Text("支出")
        .textAlign(TextAlign.Center)
        .fontColor(this.isIncomeType ? $r("app.color.black") : $r("app.color.white"))
        .borderRadius(12)
        .borderWidth(1)
        .borderColor(this.isIncomeType ? $r("app.color.primary") : $r("app.color.black"))
        .backgroundColor(this.isIncomeType ? $r("app.color.transparent") : $r("app.color.primary"))
        .padding({ top: 3, bottom: 3 })
        .width(60)
        .margin({ right: 30 })
        .onClick(() => {
          this.isIncomeType = false
          this.onChangeListener(this.isIncomeType)
        })
      Text("收入")
        .textAlign(TextAlign.Center)
        .fontColor(!this.isIncomeType ? $r("app.color.black") : $r("app.color.white"))
        .borderRadius(12)
        .borderWidth(1)
        .borderColor(!this.isIncomeType ? $r("app.color.primary") : $r("app.color.black"))
        .backgroundColor(!this.isIncomeType ? $r("app.color.transparent") : $r("app.color.primary"))
        .padding({ top: 3, bottom: 3 })
        .width(60)
        .onClick(() => {
          this.isIncomeType = true
          this.onChangeListener(this.isIncomeType)
        })
    }
  }
}