import { Bill } from '../model/ResponseModel'
import { HttpHelper } from '../network/HttpHelper'
import ReceiptItemComponent from './ReceiptItemComponent'
export enum ReceiptType {
  TYPE_EXPENSE,
  TYPE_INCOME
}

@Component
export default struct ReceiptComponent {
  receiptType: ReceiptType
  @State private bills: Bill[] = []
  @State isRefreshing: boolean = false
  private pageNum: number = 1

  aboutToAppear() {
    this.getAllBills()
  }

  build() {
    Column() {
      Refresh({ refreshing: $$this.isRefreshing }) {
        List({ space: 8}) {
          ForEach(this.bills, (bill: Bill, index: number) => {
            ListItem() {
              ReceiptItemComponent({ bill: bill })
                .margin({left: 12, right: 12})
            }
          }, item => item.billId)
        }
        .listDirection(Axis.Vertical)
        .edgeEffect(EdgeEffect.Spring)
        .width('100%')
        .height('100%')
        .onReachEnd(() => {
          this.loadMoreBills()
        })
      }
      .onRefreshing(() => {
        this.getAllBills()
      })
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
  }

  private getAllBills() {
    this.pageNum = 1
    HttpHelper.getInstance()
      .get({
        url: "/bill/getAll",
        params: { pageNum: this.pageNum, type: this.receiptType },
        onDataSuccess: (data: Bill[]) => {
          this.bills = data
        },
        onFinish: () => {
          this.isRefreshing = false
        }
      })
  }

  private loadMoreBills() {
    this.pageNum++
    HttpHelper.getInstance()
      .get({
        url: "/bill/getAll",
        params: { pageNum: this.pageNum, type: this.receiptType },
        onDataSuccess: (data: Bill[]) => {
          this.bills = this.bills.concat(data)
        }
      })
  }
}