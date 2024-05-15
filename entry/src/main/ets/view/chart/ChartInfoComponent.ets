import { McBarChart, McPieChart, Options } from '@mcui/mccharts'
import { BarChartType } from '../../model/ChartModel'
import StringUtil from '../../utils/StringUtil'

export interface PieChartBean {
  value: number,
  name: string
}

@Component
export default struct ChartInfoComponent {
  @Link pieData: PieChartBean[]
  @Link barChartType: BarChartType
  @Link barData: number[]

  build() {
    Scroll() {
      Column() {
        McPieChart({
          options: new Options({
            series: [
              {
                data: this.pieData
              }
            ]
          })
        }).height(400)
        McBarChart({
          options: new Options({
            xAxis: {
              data: StringUtil.getBarChartXAxisData(this.barChartType)
            },
            yAxis: {
              name: '单位/元'
            },
            series: [
              {
                name: '金额',
                data: this.barData,
                label: {
                  show: false
                }
              }
            ]
          })
        }).height(600).margin({ bottom: 80 })
      }
      .alignItems(HorizontalAlign.Start)
    }
  }
}