import { BarChartType } from '../../model/ChartModel'
import ChartInfoComponent, { PieChartBean } from './ChartInfoComponent'

@Component
export default struct ChartTabComponent {
  @State currentIndex: number = 0
  @Link expensePieData: PieChartBean[]
  @Link incomePieData: PieChartBean[]
  @Link barChartType: BarChartType
  @Link expenseBarData: number[]
  @Link incomeBarData: number[]

  @Builder TabBuilder(index: number, name: string) {
    Column() {
      Text(name)
        .fontColor(this.currentIndex === index ? $r('app.color.primary') : $r('app.color.gray'))
        .fontSize(16)
        .fontWeight(this.currentIndex === index ? 500 : 400)
        .lineHeight(22)
        .margin({ top: 17, bottom: 7 })
      Divider()
        .width('40%')
        .strokeWidth(2)
        .color($r('app.color.primary'))
        .opacity(this.currentIndex === index ? 1 : 0)
    }.width('100%')
  }

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.Start }) {
        TabContent() {
          ChartInfoComponent({ pieData: $expensePieData, barChartType: $barChartType, barData: $expenseBarData })
        }
        .tabBar(this.TabBuilder(0, '支出'))

        TabContent() {
          ChartInfoComponent({ pieData: $incomePieData, barChartType: $barChartType, barData: $incomeBarData })
        }
        .tabBar(this.TabBuilder(1, '收入'))
      }
      .scrollable(true)
      .barWidth('94%')
      .barMode(BarMode.Fixed)
      .vertical(false)
      .onChange((index) => {
        this.currentIndex = index;
      })
    }
    .width("100%")
    .height("100%")
    .backgroundColor($r("app.color.grayBackground"))
  }
}