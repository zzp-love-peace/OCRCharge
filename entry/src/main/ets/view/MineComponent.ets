import router from '@ohos.router'
import PreferencesUtil from '../utils/PreferencesUtil'

@Component
export default struct MineComponent {
  @State private username: string = "zzp"

  build() {
    Column() {
      Row() {
        Image($r("app.media.ic_mine_header"))
          .fillColor($r("app.color.gray"))
          .height(120)
          .width(120)
        Column() {
          Text(this.username)
            .fontSize(20)
          Text("已使用xxx天")
            .margin({ top: 36 })
        }
        .alignItems(HorizontalAlign.Start)
        .margin({ left: 30 })
      }
      .backgroundColor($r("app.color.secondary"))
      .borderRadius({ bottomLeft: 20, bottomRight: 20 })
      .padding({ left: 32 })
      .width("100%")
      .height(240)
      Text("账单")
        .margin({top: 20, left: 32})
      this.NavigationItem($r("app.media.ic_tag"), "标签", () => {
        router.pushUrl({
          url: 'pages/LabelPage'
        }, router.RouterMode.Single)
      })
      Divider()
        .margin({left: 32, right: 32, top: 20})
        .color($r("app.color.gray"))
      Text("统计")
        .margin({top: 20, left: 32})
      this.NavigationItem($r("app.media.ic_chart_year"), "年度报表", () => {
        router.pushUrl({
          url: 'pages/YearChartPage'
        }, router.RouterMode.Single)
      })
      this.NavigationItem($r("app.media.ic_chart_month"), "月度报表", () => {
        router.pushUrl({
          url: 'pages/MonthChartPage'
        }, router.RouterMode.Single)
      })
    }
    .alignItems(HorizontalAlign.Start)
    .backgroundColor($r("app.color.grayBackground"))
    .width("100%")
    .height("100%")
  }

  aboutToAppear() {
    PreferencesUtil.get("username", "", (value) => {
      this.username = value
    })
  }

  @Builder NavigationItem(icon: Resource, title: string, onClick: (() => void)) {
    Row() {
      Image(icon)
        .width(24)
        .height(24)
        .fillColor($r("app.color.black"))
      Text(title)
        .margin({left: 15})
    }
    .margin({left: 32, top: 25})
    .onClick(onClick)
    .width("100%")
  }
}