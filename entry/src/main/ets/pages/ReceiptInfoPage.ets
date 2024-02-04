import LabelUtil from '../utils/LabelUtil'
import { ReceiptType } from '../view/ReceiptComponent'
import ToolBarComponent from '../view/ToolBarComponent'
import TypeRadioComponent from '../view/TypeRadioComponent'

@Entry
@Component
struct ReceiptInfoPage {
  @State isIncome: boolean = false
  @State labelName: string = ""
  @State date: string = ""
  @State shopkeeper: string = ""
  @State remark: string = ""
  private tagSelectIndex: number = 0
  private selectedDate: Date = new Date(Date.now())


  build() {
    Column() {
      ToolBarComponent({ title: "账单详情", backIcon: true })
      Row() {
        Text("¥")
          .fontSize(55)
          .fontColor($r("app.color.primary"))
        TextInput({ placeholder: "0.00" })
          .type(InputType.Number)
          .placeholderColor($r("app.color.primary"))
          .placeholderFont({ size: 60 })
          .caretColor($r("app.color.transparent"))
          .style(TextInputStyle.Inline)
          .backgroundColor($r("app.color.transparent"))
          .padding(2)
      }
      .justifyContent(FlexAlign.Center)
      .padding({ left: 35 })

      this.NormalDivider()
      Row() {
        Image($r("app.media.ic_type"))
          .fillColor($r("app.color.primary"))
          .margin({ right: 10 })
          .width(24)
          .height(24)
        Text("类型")
          .fontSize(16)
          .margin({ right: 30 })
        TypeRadioComponent({ isIncomeType: $isIncome ,onChangeListener: (value: boolean) => {
            this.isIncome = value
        } })
      }
      .padding({ top: 10, bottom: 10, left: 35 })
      .width("100%")

      this.NormalDivider()
      Row() {
        Image($r("app.media.ic_tag_2"))
          .fillColor($r("app.color.primary"))
          .margin({ right: 10 })
          .width(24)
          .height(24)
        Text("标签")
          .fontSize(16)
        Text(this.labelName)
          .fontSize(16)
          .margin({ left: 25 })
      }
      .padding({ top: 10, bottom: 10, left: 35 })
      .width("100%")
      .onClick(() => {
        TextPickerDialog.show({
          range: LabelUtil.getLabelNameList(),
          selected: this.tagSelectIndex,
          onAccept: (value: TextPickerResult) => {
            this.tagSelectIndex = value.index
            this.labelName = LabelUtil.getLabelNameList()[value.index]
          },
        })
      })

      this.NormalDivider()
      Row() {
        Image($r("app.media.ic_time_2"))
          .fillColor($r("app.color.primary"))
          .margin({ right: 10 })
          .width(24)
          .height(24)
        Text("时间")
          .fontSize(16)
        Text(this.date)
          .fontSize(16)
          .margin({ left: 25 })
      }
      .padding({ top: 10, bottom: 10, left: 35 })
      .width("100%")
      .onClick(() => {
        DatePickerDialog.show({
          start: new Date("2000-1-1"),
          end: new Date("2100-12-31"),
          selected: this.selectedDate,
          onAccept: (value: DatePickerResult) => {
            this.selectedDate.setFullYear(value.year, value.month, value.day)
            this.date = `${value.year}-${value.month + 1}-${value.day}`
          },
        })
      })
    }
    .backgroundColor($r("app.color.grayBackground"))
    .width("100%")
    .height("100%")
  }

  @Builder NormalDivider() {
    Divider()
      .color($r("app.color.primary"))
      .width(2)
      .margin({ left: 30, bottom: 10 })
      .width("100%")
  }
}