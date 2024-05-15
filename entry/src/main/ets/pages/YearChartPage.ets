import { BarChartType } from '../model/ChartModel'
import { YearChartData, YearLabelData } from '../model/ResponseModel'
import { ChartService } from '../service/ChartService'
import { PieChartBean } from '../view/chart/ChartInfoComponent'
import ChartTabComponent from '../view/chart/ChartTabComponent'
import ToolBarComponent from '../view/common/ToolBarComponent'

@Entry
@Component
struct YearChartPage {
  @State expensePieData: PieChartBean[] = []
  @State incomePieData: PieChartBean[] = []
  @State expenseBarData: number[] = []
  @State incomeBarData: number[] = []
  @State barChartType: BarChartType = BarChartType.TYPE_YEAR
  private chartService: ChartService = new ChartService()

  aboutToAppear() {
    let nowDate = new Date(Date.now())
    let year: number = nowDate.getFullYear()
    this.getYearExpenseData(year)
    this.getYearIncomeData(year)
    this.getYearLabelExpense(year)
    this.getYearLabelIncome(year)
  }

  build() {
    Column() {
      ToolBarComponent({
        title: '年度报表',
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

  private getYearExpenseData(year: number) {
    this.chartService.getYearExpenseData(year, (data: YearChartData) => {
      this.expenseBarData = data.monthSum
    })
  }

  private getYearIncomeData(year: number) {
    this.chartService.getYearIncomeData(year, (data: YearChartData) => {
      this.incomeBarData = data.monthSum.map(item => Math.abs(item))
    })
  }

  private getYearLabelExpense(year: number) {
    this.chartService.getYearLabelExpense(year, (data: YearLabelData) => {
      this.expensePieData = data.yearLabelData
    })
  }

  private getYearLabelIncome(year: number) {
    this.chartService.getYearLabelIncome(year, (data: YearLabelData) => {
      this.incomePieData = data.yearLabelData
    })
  }
}