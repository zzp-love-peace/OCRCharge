import { NavList, TabId } from '../model/NavItemModel';
import MineComponent from '../view/MineComponent';
import ReceiptTabComponent from '../view/ReceiptTabComponent';

@Entry
@Component
struct MainPage {
  @State currentPage: number = 1
  @State pageVisible: boolean = false

  onPageShow() {
    this.pageVisible = true
  }

  onPageHide() {
    this.pageVisible = false
  }

  build() {
    Tabs({ barPosition: BarPosition.End, index: 1 }) {
      TabContent() {
        Column() {
          Text('图表')
        }
      }
      .tabBar(this.TabBuilder(TabId.CHAT))

      TabContent() {
        ReceiptTabComponent({ pageVisible: $pageVisible })
      }
      .tabBar(this.TabBuilder(TabId.RECEIPT))

      TabContent() {
        MineComponent()
      }
      .tabBar(this.TabBuilder(TabId.MINE))
    }
    .scrollable(false)
    .width('100%')
    .height('100%')
    .barWidth('94%')
    .barMode(BarMode.Fixed)
    .vertical(false)
    .onChange((index) => {
      this.currentPage = index;
    })
  }

  @Builder TabBuilder(index: number) {
    Column() {
      Image(NavList[index].icon)
        .width($r('app.float.default_24'))
        .height($r('app.float.default_24'))
        .fillColor(index === this.currentPage ? $r('app.color.primary') : $r('app.color.gray'))
        .objectFit(ImageFit.Contain);
      Text(NavList[index].text)
        .fontSize($r('app.float.default_10'))
        .fontWeight(500)
        .fontColor(this.currentPage === index ? $r('app.color.primary') : $r('app.color.gray'))
        .margin({ top: $r('app.float.default_4') })
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%')
  }
}