import { BarChartType } from '../../model/ChartModel'
import { MonthChartData, MonthLabelData, WeekChartData, WeekLabelData } from '../../model/ResponseModel'
import { HttpHelper } from '../../network/HttpHelper'
import { ChartService } from '../../service/ChartService'
import Logger from '../../utils/Logger'
import StringUtil from '../../utils/StringUtil'
import ToolBarComponent from '../common/ToolBarComponent'
import { PieChartBean } from './ChartInfoComponent'
import ChartTabComponent from './ChartTabComponent'

@Component
export default struct ChartComponent {
  @State title: string = StringUtil.getNowFormatMonthAndYear()
  @State expensePieData: PieChartBean[] = []
  @State incomePieData: PieChartBean[] = []
  @State barChartType: BarChartType = BarChartType.TYPE_MONTH
  @State expenseBarData: number[] = []
  @State incomeBarData: number[] = []
  private selectedDate: Date = new Date(Date.now())
  private chartService: ChartService = new ChartService()

  aboutToAppear() {
    let nowDate = new Date(Date.now())
    let year: number = nowDate.getFullYear()
    let month: number = nowDate.getMonth() + 1
    this.getMonthExpenseData(year, month)
    this.getMonthIncomeData(year, month)
    this.getMonthLabelExpense(year, month)
    this.getMonthLabelIncome(year, month)
  }

  build() {
    Column() {
      ToolBarComponent({
        title: this.title,
        icons: [{ icon: $r('app.media.ic_time'), onClick: () => {
          this.showWeekDialog()
        } }, { icon: $r('app.media.ic_calendar'), onClick: () => {
          this.showSelectMonthDialog()
        } }]
      })
      ChartTabComponent({
        expensePieData: $expensePieData,
        incomePieData: $incomePieData,
        barChartType: $barChartType,
        expenseBarData: $expenseBarData,
        incomeBarData: $incomeBarData
      })
    }
    .alignItems(HorizontalAlign.Start)
    .backgroundColor($r("app.color.grayBackground"))
    .width("100%")
    .height("100%")
  }

  private getMonthExpenseData(year: number, month: number) {
    this.chartService.getMonthExpenseData(year, month, (data: MonthChartData) => {
      this.expenseBarData = data.everyday
    })
  }

  private getWeekExpenseData() {
    this.chartService.getWeekExpenseData((data: WeekChartData) => {
      this.expenseBarData = data.everyday.reverse()
    })
  }

  private getMonthIncomeData(year: number, month: number) {
    this.chartService.getMonthIncomeData(year, month, (data: MonthChartData) => {
      this.incomeBarData = data.everyday.map(item => Math.abs(item))
    })
  }

  private getWeekIncomeData() {
    this.chartService.getWeekIncomeData((data: WeekChartData) => {
      this.incomeBarData = data.everyday.reverse().map(item => Math.abs(item))
    })
  }

  private getWeekLabelExpense() {
    this.chartService.getWeekLabelExpense((data: WeekLabelData) => {
      this.expensePieData = data.weekLabelData
    })
  }

  private getWeekLabelIncome() {
    this.chartService.getWeekLabelIncome((data: WeekLabelData) => {
      this.incomePieData = data.weekLabelData
    })
  }

  private getMonthLabelExpense(year: number, month: number) {
    this.chartService.getMonthLabelExpense(year, month, (data: MonthLabelData) => {
      this.expensePieData = data.monthLabelData
    })
  }

  private getMonthLabelIncome(year: number, month: number) {
    this.chartService.getMonthLabelIncome(year, month, (data: MonthLabelData) => {
      this.incomePieData = data.monthLabelData
    })
  }

  private showWeekDialog() {
    AlertDialog.show(
      {
        title: '提示',
        message: '查看最近七天的账单',
        autoCancel: true,
        alignment: DialogAlignment.Center,
        gridCount: 4,
        primaryButton: {
          value: '取消',
          action: () => {
          }
        },
        secondaryButton: {
          value: '确定',
          action: () => {
            this.getWeekLabelExpense()
            this.getWeekLabelIncome()
            this.barChartType = BarChartType.TYPE_WEEK
            this.getWeekExpenseData()
            this.getWeekIncomeData()
            this.title = "最近一周"
          }
        },
      }
    )
  }

  private showSelectMonthDialog() {
    DatePickerDialog.show({
      start: new Date("2000-1-1"),
      end: new Date("2100-12-31"),
      selected: this.selectedDate,
      onAccept: (value: DatePickerResult) => {
        this.selectedDate.setFullYear(value.year, value.month, value.day)
        this.barChartType = BarChartType.TYPE_MONTH
        this.title = StringUtil.getFormatMonthAndYear(value.year, value.month + 1)
        this.getMonthExpenseData(value.year, value.month + 1)
        this.getMonthIncomeData(value.year, value.month + 1)
        this.getMonthLabelExpense(value.year, value.month + 1)
        this.getMonthLabelIncome(value.year, value.month + 1)
      },
    })
  }
}