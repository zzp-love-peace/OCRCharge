import router from '@ohos.router'
import { ReceiptItemPageType } from '../model/ReceiptModel'
import { Bill } from '../model/ResponseModel'
import BillUtil from '../utils/BillUtil'
import LabelUtil from '../utils/LabelUtil'
import ReceiptTabComponent from './ReceiptTabComponent'

@Component
export default struct ReceiptItemComponent {
  @State bill: Bill = {
    billId: -1,
    labelId: -1,
    userId: -1,
    money: 0,
    time: '',
    shopkeeper: ''
  }
  receiptItemPageType: ReceiptItemPageType

  build() {
    Row() {
      Image(BillUtil.isBillIncome(this.bill) ? $r("app.media.ic_income") : $r("app.media.ic_expense"))
        .fillColor($r("app.color.black"))
        .width(24)
        .height(24)
      Text(LabelUtil.getLabelNameFormId(this.bill.labelId))
        .margin({ left: 16 })
      Text("¥")
        .fontColor($r("app.color.primary"))
        .margin({ left: 16 })
      Text(Math.abs(this.bill.money).toString())
        .fontColor($r("app.color.primary"))
      Blank()
      Text(this.bill.shopkeeper.substring(0, Math.min(this.bill.shopkeeper.length, 7)))
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      Blank()
      Text(this.bill.time.split(' ')[0])
        .margin({ left: 8 })
    }
    .borderRadius(8)
    .borderWidth(1.5)
    .borderColor($r("app.color.primary"))
    .padding({ left: 8, right: 8 })
    .width("100%")
    .height(68)
    .onClick(() => {
      router.pushUrl({
        url: "pages/ReceiptInfoPage",
        params: {
          bill: this.bill,
          backRouterName: this.receiptItemPageType === ReceiptItemPageType.TYPE_MAIN_TAB
            ? "pages/MainPage" : "pages/SearchPage",
          pageChangeCount: ReceiptTabComponent.pageChangeCount
        }
      })
    })
  }
}