import { ReceiptType } from '../model/ReceiptModel'
import { Bill } from '../model/ResponseModel'

class BillUtil {

  public getBillType(bill: Bill): ReceiptType {
    return bill.money > 0 ? ReceiptType.TYPE_EXPENSE : ReceiptType.TYPE_INCOME
  }

  public isBillIncome(bill: Bill) {
    return this.getBillType(bill) === ReceiptType.TYPE_INCOME
  }
}

export default new BillUtil()