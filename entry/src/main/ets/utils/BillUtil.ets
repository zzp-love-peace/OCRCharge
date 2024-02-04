import { Bill } from '../model/ResponseModel'
import { ReceiptType } from '../view/ReceiptComponent'
class BillUtil {

  public getBillType(bill: Bill): ReceiptType {
    return bill.money > 0 ? ReceiptType.TYPE_EXPENSE : ReceiptType.TYPE_INCOME
  }

  public isBillIncome(bill: Bill) {
    return this.getBillType(bill) === ReceiptType.TYPE_INCOME
  }
}

export default new BillUtil()