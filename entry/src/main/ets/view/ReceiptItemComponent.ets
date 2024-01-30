import { Bill } from '../model/ResponseModel'
import LabelUtil from '../utils/LabelUtil'

@Component
export default struct ReceiptItemComponent {

  @State bill: Bill = {billId: -1, labelId: -1, userId: -1, money: 0, time: '', shopkeeper: ''}

  build() {
    Row() {
      Image($r("app.media.ic_receipt_item"))
        .width(24)
        .height(24)
      Text(LabelUtil.getLabelNameFormId(this.bill.labelId))
        .margin({left: 16})
      Text("¥")
        .fontColor($r("app.color.primary"))
        .margin({left: 16})
      Text(this.bill.money.toString())
        .fontColor($r("app.color.primary"))
      Blank()
      Text(this.bill.shopkeeper.substring(0, Math.min(this.bill.shopkeeper.length, 7)))
        .maxLines(1)
        .textOverflow({overflow: TextOverflow.Ellipsis})
      Blank()
      Text(this.bill.time.split(' ')[0])
        .margin({left: 8})
    }
    .borderRadius(8)
    .borderWidth(1.5)
    .borderColor($r("app.color.primary"))
    .padding({left: 8, right: 8})
    .width("100%")
    .height(68)
  }

}