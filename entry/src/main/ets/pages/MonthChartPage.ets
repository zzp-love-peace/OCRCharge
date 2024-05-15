import { BarChartType } from '../model/ChartModel'
import { MonthChartData, MonthLabelData, WeekChartData, WeekLabelData } from '../model/ResponseModel'
import { ChartService } from '../service/ChartService'
import { PieChartBean } from '../view/chart/ChartInfoComponent'
import ChartTabComponent from '../view/chart/ChartTabComponent'
import ToolBarComponent from '../view/common/ToolBarComponent'
@Entry
@Component
struct MonthChartPage {
  @State expensePieData: PieChartBean[] = []
  @State incomePieData: PieChartBean[] = []
  @State expenseBarData: number[] = []
  @State incomeBarData: number[] = []
  @State barChartType: BarChartType = BarChartType.TYPE_MONTH
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
        title: '月度报表',
        backIcon: true
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

  private getMonthIncomeData(year: number, month: number) {
    this.chartService.getMonthIncomeData(year, month, (data: MonthChartData) => {
      this.incomeBarData = data.everyday.map(item => Math.abs(item))
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
}