import router from '@ohos.router'
import { ReceiptHandleType, ReceiptItemPageType, ReceiptType } from '../model/ReceiptModel'
import { Bill } from '../model/ResponseModel'
import { HttpHelper } from '../network/HttpHelper'
import ReceiptItemComponent from './ReceiptItemComponent'
import ReceiptTabComponent from './ReceiptTabComponent'

@Component
export default struct ReceiptComponent {
  receiptType: ReceiptType
  @State private bills: Bill[] = []
  @State isRefreshing: boolean = false
  @Link @Watch('onPageVisibilityChange') pageVisible: boolean
  private pageNum: number = 1

  aboutToAppear() {
    this.getAllBills()
  }

  onPageVisibilityChange() {
    if (this.pageVisible) {
      try {
        let handleType: ReceiptHandleType | null = (router.getParams() as Record<string, ReceiptHandleType | null>)['handleType']
        let data: Bill | null = (router.getParams() as Record<string, Bill | null>)['data']
        let newPageChangeCount: number = (router.getParams() as Record<string, number | null>)['pageChangeCount']
        if (handleType !== null && data !== null && newPageChangeCount !== null && ReceiptTabComponent.pageChangeCount < newPageChangeCount) {
          ReceiptTabComponent.pageChangeCount = newPageChangeCount
          switch (handleType) {
            case ReceiptHandleType.TYPE_ADD:
              this.bills.unshift(data)
              let newBills = []
              newBills = newBills.concat(this.bills)
              this.bills = newBills
              break
            case ReceiptHandleType.TYPE_REMOVE:
              this.bills = this.bills.filter(bill => bill.billId !== data.billId)
              break
            case ReceiptHandleType.TYPE_UPDATE:
              this.bills = this.bills.map(bill => {
                if (bill.billId === data.billId) {
                  return data
                }
                return bill
              })
              break
          }
        }
      } catch (e) {
      }
    }
  }

  build() {
    Column() {
      Refresh({ refreshing: $$this.isRefreshing }) {
        List({ space: 8 }) {
          ForEach(this.bills, (bill: Bill, index: number) => {
            ListItem() {
              ReceiptItemComponent({
                bill: bill,
                receiptItemPageType: ReceiptItemPageType.TYPE_MAIN_TAB
              })
                .margin({ left: 12, right: 12 })
            }
          }, item => JSON.stringify(item))
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