import { Bill } from '../model/ResponseModel'
import { HttpHelper } from '../network/HttpHelper'
import LabelUtil from '../utils/LabelUtil'
import ReceiptItemComponent from '../view/ReceiptItemComponent'
import ToolBarComponent from '../view/ToolBarComponent'

@Entry
@Component
struct SearchPage {
  @State dateStr: string = "全部时间"
  @State tagStr: string = "所有标签"
  @State isRefreshing: boolean = false
  @State private bills: Bill[] = []
  private tagSelectIndex: number = 0
  private selectedDate: Date = new Date(Date.now())
  private pageNum: number = 1

  build() {
    Column() {
      ToolBarComponent({ title: "搜索", backIcon: true })
      Row() {
        Row() {
          Image($r("app.media.ic_time"))
            .fillColor($r("app.color.black"))
            .width(24)
            .height(24)
          Text(this.dateStr)
            .margin({ left: 5 })
        }
        .padding({ top: 2, bottom: 2, left: 7, right: 7 })
        .borderColor($r("app.color.black"))
        .borderWidth(1.5)
        .borderRadius(10)
        .onClick(() => {
          DatePickerDialog.show({
            start: new Date("2000-1-1"),
            end: new Date("2100-12-31"),
            selected: this.selectedDate,
            onAccept: (value: DatePickerResult) => {
              // 通过Date的setFullYear方法设置按下确定按钮时的日期，这样当弹窗再次弹出时显示选中的是上一次确定的日期
              this.selectedDate.setFullYear(value.year, value.month, value.day)
              this.dateStr = `${value.year}-${value.month + 1}-${value.day}`
              this.getBillsByCondition()
            },
          })
        })
        Blank()
        Row() {
          Image($r("app.media.ic_tag"))
            .fillColor($r("app.color.black"))
            .width(24)
            .height(24)
          Text(this.tagStr)
            .margin({ left: 5 })
        }
        .padding({ top: 2, bottom: 5, left: 7, right: 7 })
        .borderColor($r("app.color.black"))
        .borderWidth(1.5)
        .borderRadius(10)
        .onClick(() => {
          TextPickerDialog.show({
            range: LabelUtil.getLabelNameList(),
            selected: this.tagSelectIndex,
            onAccept: (value: TextPickerResult) => {
              // 设置select为按下确定按钮时候的选中项index，这样当弹窗再次弹出时显示选中的是上一次确定的选项
              this.tagSelectIndex = value.index
              this.tagStr = LabelUtil.getLabelNameList()[value.index]
              this.getBillsByCondition()
            },
          })
        })
      }
      .padding({ left: 22, right: 22, top: 5, bottom: 5 })
      .width("100%")
      Refresh({ refreshing: $$this.isRefreshing }) {
        List({ space: 8}) {
          ForEach(this.bills, (bill: Bill) => {
            ListItem() {
              ReceiptItemComponent({ bill: bill })
                .margin({left: 12, right: 12})
            }
          }, item => item.billId)
        }
        .listDirection(Axis.Vertical)
        .edgeEffect(EdgeEffect.Spring)
        .width('100%')
        .onReachEnd(() => {
          this.loadMoreBills()
        })
      }
      .onRefreshing(() => {
        this.getBillsByCondition()
      })
      .width('100%')
      .layoutWeight(1)
    }
    .width("100%")
    .height("100%")
    .backgroundColor($r("app.color.grayBackground"))

  }

  private getBillsByCondition() {
    let date = this.dateStr
    if (date === '全部时间') {
      date = ""
    }
    let labelId = LabelUtil.getLabelIdFromName(this.tagStr)
    this.pageNum = 1
    HttpHelper.getInstance()
      .get({
        url: "/bill/getByCondition",
        params: { pageNum: this.pageNum, startTime: date, endTime: "", labelId: labelId },
        onDataSuccess: (data: Bill[], msg) => {
          this.bills = data
        },
        onFinish: () => {
          this.isRefreshing = false
        }
      })
  }

  private loadMoreBills() {
    let date = this.dateStr
    if (date === '全部时间') {
      date = ""
    }
    let labelId = LabelUtil.getLabelIdFromName(this.tagStr)
    this.pageNum++
    HttpHelper.getInstance()
      .get({
        url: "/bill/getByCondition",
        params: { pageNum: this.pageNum, startTime: date, endTime: "", labelId: labelId },
        onDataSuccess: (data: Bill[]) => {
          this.bills = this.bills.concat(data)
        }
      })
  }
}